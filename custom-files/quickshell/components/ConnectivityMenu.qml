import QtQuick
import QtQuick.Layouts

import qs.theme
import qs.widgets

AbstractBarButton {
    id: connectivityMenu
    implicitWidth: layout.width
    implicitHeight: Theme.barHeight - (Theme.margin)
    background: Rectangle {
        color: "transparent"
    }

    RowLayout {
        id: layout
        spacing: Theme.padding

        NetworkPill {
            id: networkPill
            action: connectivityMenu.action
        }

        BluetoothPill {
            id: bluetoothPill
            action: connectivityMenu.action
        }
    }

    sidebarComponent: "connectivity-menu"
}
