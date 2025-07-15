import QtQuick
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
            spacing: Theme.padding

            ClockWidget {
                id: clockwidget
            }
        }

        BarGroup {
            id: centerPanel
            anchors.centerIn: parent
            spacing: Theme.padding

            HyprlandWS {
                id: hyprgaming
            }
        }

        BarGroup {
            id: rightPanel
            anchors.right: parent.right
            spacing: Theme.padding

            BarGroupLoader {
                active: Battery.isAvailable
                sourceComponent: BatteryMenu {
                    id: batteryMenu
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
