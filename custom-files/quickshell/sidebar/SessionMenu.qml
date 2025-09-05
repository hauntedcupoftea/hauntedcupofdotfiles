import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.theme
import qs.config
import qs.components.internal

Rectangle {
    id: root
    property string hoveredAction: "Session Menu"
    property list<string> sessionMessages: Settings.sessionMessages

    function getRandomSessionMessage(messages) {
        const randomIndex = Math.floor(Math.random() * sessionMessages.length);
        nameReset.running = true;
        return sessionMessages[randomIndex];
    }
    Behavior on height {
        NumberAnimation {
            duration: 200 // milliseconds
            easing.type: Easing.OutCubic
        }
    }

    Timer {
        id: nameReset
        interval: 2500
        running: false
        onTriggered: root.hoveredAction = "Session Menu"
    }
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface_container_high

    border {
        width: 1
        color: Theme.colors.outline
    }

    ColumnLayout {
        id: sessionMenuColumn

        spacing: Theme.padding
        anchors.centerIn: parent
        RowLayout {
            id: sessionMenuGrid
            Layout.alignment: Qt.AlignCenter
            spacing: Theme.padding * 2

            SessionMenuButton {
                buttonIcon: "󰍃"
                buttonText: "Logout"
                Layout.alignment: Qt.AlignCenter
                command: ["uwsm", "stop"]
                onHoveredChanged: {
                    if (hovered)
                        root.hoveredAction = this.buttonText;
                    else
                        root.hoveredAction = root.getRandomSessionMessage();
                }
            }
            SessionMenuButton {
                buttonIcon: "󰜉"
                buttonText: "Reboot"
                Layout.alignment: Qt.AlignCenter
                command: ["systemctl", "reboot"]
                onHoveredChanged: {
                    if (hovered)
                        root.hoveredAction = this.buttonText;
                    else
                        root.hoveredAction = root.getRandomSessionMessage();
                }
            }
            SessionMenuButton {
                buttonIcon: "󰐥"
                buttonText: "Shutdown"
                Layout.alignment: Qt.AlignCenter
                command: ["systemctl", "poweroff"]
                onHoveredChanged: {
                    if (hovered)
                        root.hoveredAction = this.buttonText;
                    else
                        root.hoveredAction = root.getRandomSessionMessage();
                }
            }
            SessionMenuButton {
                buttonIcon: "󰌾"
                buttonText: "Lock"
                Layout.alignment: Qt.AlignCenter
                command: ["loginctl", "lock-session"]
                onHoveredChanged: {
                    if (hovered)
                        root.hoveredAction = this.buttonText;
                    else
                        root.hoveredAction = root.getRandomSessionMessage();
                }
            }
            SessionMenuButton {
                buttonIcon: "󰤄"
                buttonText: "Hibernate"
                Layout.alignment: Qt.AlignCenter
                command: ["systemctl", "hibernate"]
                onHoveredChanged: {
                    if (hovered)
                        root.hoveredAction = this.buttonText;
                    else
                        root.hoveredAction = root.getRandomSessionMessage();
                }
            }
            SessionMenuButton {
                buttonIcon: "󰜗"
                buttonText: "Suspend"
                command: ["systemctl", "suspend"]
                Layout.alignment: Qt.AlignCenter
                onHoveredChanged: {
                    if (hovered) {
                        root.hoveredAction = this.buttonText;
                    } else
                        nameReset.running = false;
                    root.hoveredAction = root.getRandomSessionMessage();
                }
            }
        }

        Text {
            id: sessionMenuText
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: sessionMenuGrid.width
            text: root.hoveredAction
            color: Theme.colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font {
                family: Theme.font.family
                pixelSize: Theme.font.normal
            }
        }
    }
}
