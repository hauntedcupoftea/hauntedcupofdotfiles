pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.theme

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
            sidebarTitle: "Left"
            anchors.left: parent.left
            spacing: Theme.padding
            screenHeight: bar.screenHeight
            screenWidth: bar.screenWidth
            gravity: Edges.Bottom | Edges.Right
            position: Qt.rect(Theme.padding, Theme.barHeight + Theme.padding, 0, 0)
            widthRatio: 0.3
            heightRatio: 1

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
            sidebarTitle: "Center"
            anchors.centerIn: parent
            screenHeight: bar.screenHeight
            screenWidth: bar.screenWidth
            spacing: Theme.padding
            widthRatio: 0.5
            heightRatio: 0.6
            gravity: Edges.Bottom
            position: Qt.rect(0.5 * centerPanel.width, Theme.barHeight + Theme.padding, 0, 0)
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
            sidebarTitle: "Right"
            anchors.right: parent.right
            screenHeight: bar.screenHeight
            screenWidth: bar.screenWidth
            spacing: Theme.padding
            gravity: Edges.Bottom | Edges.Right
            position: Qt.rect(rightPanel.width - Theme.padding, Theme.barHeight + Theme.padding, 0, 0)
            widthRatio: 0.3
            heightRatio: 1

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
        }
    }
}
