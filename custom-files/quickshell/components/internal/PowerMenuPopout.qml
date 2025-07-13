import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme"

PopupWindow {
    id: root
    required property var powerButton
    required property bool popupOpen
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }
    color: "transparent"

    implicitWidth: powerMenuGrid.width + (Theme.padding * 2)
    implicitHeight: powerMenuGrid.height + (Theme.padding * 2)
    visible: popupOpen

    Behavior on visible {}

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onExited: {
                root.powerButton.action.trigger();
            }

            GridLayout {
                id: powerMenuGrid
                anchors.centerIn: parent
                columnSpacing: Theme.padding
                rowSpacing: Theme.padding
                columns: 3

                ActionButton {
                    buttonIcon: "󰍃"
                    buttonText: "Logout"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                }
                ActionButton {
                    buttonIcon: "󰜉"
                    buttonText: "Reboot"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                }
                ActionButton {
                    buttonIcon: "󰐥"
                    buttonText: "Shutdown"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                }
                ActionButton {
                    buttonIcon: "󰌾"
                    buttonText: "Lock"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                    command: ["loginctl", "lock-session"]
                }
                ActionButton {
                    buttonIcon: "󰤄"
                    buttonText: "Hibernate"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                }
                ActionButton {
                    buttonIcon: "󰜗"
                    buttonText: "Suspend"
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 108
                }
            }
        }
    }
}
