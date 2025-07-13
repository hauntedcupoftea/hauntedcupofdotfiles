// import Quickshell
import QtQuick
// import QtQuick.Layouts
import "../components"
import "../theme"
import "../services"

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
        anchors.margins: Theme.margin
        anchors.fill: parent

        BarGroup {
            id: leftPanel
            anchors.left: parent.left
            spacing: Theme.margin + Theme.padding

            ClockWidget {
                id: clockwidget
            }
        }

        BarGroup {
            id: rightPanel
            anchors.right: parent.right
            spacing: Theme.padding

            Loader {
                active: Battery.isAvailable
                sourceComponent: BatteryMenu {
                    id: batterymenu
                }
            }

            ConnectivityMenu {
                id: connectivityMenu
            }

            SessionMenu {
                id: sessionMenu
            }
        }
    }
}
