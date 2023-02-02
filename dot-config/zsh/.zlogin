if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
    export XDG_CURRENT_DESKTOP=sway
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export _JAVA_AWT_WM_NONREPARENTING=1

    exec sway
fi
