#!/usr/bin/env python3

import json
import os
import subprocess
import sys

from pathlib import Path
from typing import List

XDG_RUNTIME_DIR: Path = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
QUAKE_KITTY_SOCK: Path = XDG_RUNTIME_DIR / "quake_kitty.sock"
SWAY_SOCK: Path = Path(os.environ["SWAYSOCK"])  # throws KeyError


def errexit(msg: str, exitcode: int = 1):
    print(msg, file=sys.stderr, flush=True)
    #sys.exit(exitcode)


def swaymsg_send(cmd: List[str]) -> dict | None:

    if not cmd:
        return

    command = [
        "/usr/bin/swaymsg",
        f"--socket={SWAY_SOCK.as_posix()}",
        "--raw",
    ] + cmd

    result: subprocess.CompletedProcess = subprocess.run(command, capture_output=True, text=True)

    if result.returncode == 1:
        errexit(f"error communicating with sway: syntax error: {' '.join(command)}")
    elif result.returncode == 2:
        errexit(f"error communicating with sway: invalid command: {' '.join(command)}")

    if result.stdout:
        return json.loads(result.stdout)
    return None


def get_window_tree() -> dict:

    tree: dict | None = swaymsg_send(["--type" , "get_tree"])
    if not tree:
        errexit("error communicating with sway: no window tree available")
        return dict()  # silence pyright
    return tree


def find_node() -> dict | None:

    def tree_iter(tree: dict) -> dict | None:

        if tree.get("name", "") == "quake_kitty" and tree.get("app_id", "") == "quake_kitty":
            return tree

        nodes: List[dict] = tree.get("floating_nodes", []) + tree.get("nodes", [])

        for node in nodes:
            res = tree_iter(node)
            if res:
                return res

        return None

    return tree_iter(get_window_tree())


def print_state():
    tree: dict | None = find_node()

    if tree:
        print()
        print(f"focused: {tree.get('focused', 'dont know')}")
        print(f"focus: {tree.get('focus', 'dont know')}")
        print(f"sticky: {tree.get('sticky', 'dont know')}")
        print(f"scratchpad_state: {tree.get('scratchpad_state', 'dont know')}")
        print(f"visible: {tree.get('visible', False)}")
        print()


def is_visible() -> bool:
    tree: dict | None = find_node()
    if tree:
        return tree.get("visible", False)
    return False


def is_focused() -> bool:
    tree: dict | None = find_node()
    if tree:
        return tree.get("focused", False)
    return False


def launch_quake_kitty():

    command = [
        "/usr/bin/kitty",
        f"--listen-on=unix:{QUAKE_KITTY_SOCK.as_posix()}",
        "--title=quake_kitty",
        "--app-id=quake_kitty",
        "--instance-group=quake_kitty",
        "--single-instance",
        #"--wait-for-single-instance-window-close",
        "--override=background_opacity=0.7",
        "--override=allow_remote_control=socket",
        "--detach",
    ]

    result: subprocess.CompletedProcess = subprocess.run(command, capture_output=False)
    try:
        result.check_returncode()
    except subprocess.CalledProcessError as e:
        errexit(f"error launching quake_kitty: {e}")

def move_to_scratchpad():
    swaymsg_send(["[app_id=quake_kitty]" , "move", "container", "to", "scratchpad"])

def focus():
    swaymsg_send([
        "[app_id=quake_kitty]",
        "focus", ";",
        "move", "to", "output", "current", ";",
        "resize", "set", "100", "ppt", "50", "ppt", ";",
        "move", "position", "0", "px", "0", "px",
    ])

if not QUAKE_KITTY_SOCK.exists():
    launch_quake_kitty()
    focus()
else:
    if is_focused():
        move_to_scratchpad()
    else:
        focus()
