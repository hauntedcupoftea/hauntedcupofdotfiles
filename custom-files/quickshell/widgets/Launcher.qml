import QtQuick
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: root

    HyprlandFocusGrab {
        active: root.visible
        windows: [root]
        onCleared: {
            root.visible = false;
        }
    }
}
