pragma ComponentBehavior: Bound
import QtQuick
// import QtQuick.Layouts

import qs.components
import qs.theme

// import qs.services

Rectangle {
    id: bar
    property var modelData
    color: Theme.colors.base

    anchors {
        top: parent.top
        topMargin: Theme.debugOffsetHeight
        left: parent.left
        right: parent.right
    }

    implicitHeight: Theme.barHeight

    Item {
        anchors.margins: Theme.margin / 2
        anchors.fill: parent

        BarGroup {
            id: leftPanel
            anchors.left: parent.left
            spacing: Theme.padding

            ClockWidget {
                id: clockwidget
            }
            ActiveWindow {
                id: activeWindowName
            }
        }

        PlayerMenu {
            id: player
            anchors.right: hyprgaming.left
            anchors.rightMargin: Theme.padding
        }
        HyprlandWS {
            id: hyprgaming
            anchors.centerIn: parent
        }

        BarGroup {
            id: rightPanel
            anchors.right: parent.right
            spacing: Theme.padding

            ConnectivityMenu {
                id: connectivityMenu
            }

            BatteryMenu {
                id: batteryMenu
            }

            SystemTray {
                id: sysTray
            }

            SessionMenu {
                id: sessionMenu
            }
        }
    }
}
