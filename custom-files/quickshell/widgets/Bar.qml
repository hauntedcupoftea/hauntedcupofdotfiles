pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
// import QtQuick.Layouts

import qs.components
import qs.theme
import qs.services

// import qs.services

Rectangle {
    id: bar
    property var modelData
    property real screenHeight
    property real screenWidth
    color: Theme.colors.surface

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

            Component.onCompleted: print(bar.screenHeight, bar.screenWidth)

            OSButton {
                Layout.leftMargin: Theme.padding
            }
            ClockWidget {
                id: clockwidget
            }
            ActiveWindow {
                id: activeWindowName
            }
        }

        BarGroup {
            id: centerPanel
            anchors.centerIn: parent
            spacing: Theme.padding
            PlayerMenu {
                id: player
            }
            HyprlandWS {
                id: hyprgaming
                Layout.alignment: Qt.AlignCenter
            }
            VolumeMenu {
                id: volumeGaming
            }
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

            NotificationCenter {
                id: notifications
            }

            SessionMenu {
                id: sessionMenu
            }
        }
    }
}
