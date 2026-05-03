pragma ComponentBehavior: Bound
import qs.services
import qs.components

import Quickshell.Wayland
import QtQuick

WlSessionLock {
    id: lockScreen

    locked: LockContext.locked

    WlSessionLockSurface {
        id: lockSurface
        LockScreen {
            screen: lockSurface.screen
            anchors.fill: parent
        }
    }
}
