import qs.services
import qs.components

import Quickshell.Wayland
import QtQuick

WlSessionLock {
    id: lockScreen

    locked: LockContext.locked

    WlSessionLockSurface {
        LockScreen {
            anchors.fill: parent
        }
    }
}
