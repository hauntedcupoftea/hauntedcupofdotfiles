import QtQuick
import QtQuick.Layouts
import "../components"
import "../theme"

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

        HyprlandWS {
            id: hyprgaming
            anchors.centerIn: parent
            Layout.alignment: Qt.AlignCenter
        }

        BarGroup {
            id: rightPanel
            anchors.right: parent.right
            spacing: Theme.padding

            BatteryMenu {
                id: batteryMenu
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
