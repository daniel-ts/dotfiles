#!/run/current-system/sw/bin/env python3
import json
import subprocess
import sys

def get_state():
    try:
        return subprocess.check_output(["darkman", "get"], text=True).strip()
    except subprocess.CalledProcessError:
        return "light"  # fallback

def print_status():
    state = get_state()
    cls = "on" if state == "dark" else "off"
    print(json.dumps({
        "class": cls,
        "alt": cls,
        "tooltip": f"Theme: {state}"
    }))

def send_signal():
    """
    RTMIN+5 corresponds to `"signal": 5` in Waybar.
    Triggers Waybar to re-run the exec command for this module.
    """
    subprocess.run(["pkill", "-RTMIN+5", "waybar"], check=False)

def toggle_state():
    subprocess.run(["darkman", "toggle"],
                   check=False,
                   stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)

if __name__ == "__main__":
    if len(sys.argv) == 1 or sys.argv[1] == "status":
        print_status()
    elif sys.argv[1] == "toggle":
        toggle_state()
        print_status()
        #send_signal()
    else:
        sys.exit(f"Unknown command: {sys.argv[1]}")
