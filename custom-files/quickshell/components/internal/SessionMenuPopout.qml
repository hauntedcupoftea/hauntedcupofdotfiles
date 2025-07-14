import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../config"

PopupWindow {
    id: root
    required property var powerButton
    required property bool popupOpen
    property string hoveredAction: "Session Menu"
    property list<string> sessionMessages: Settings.sessionMessages

    function getRandomSessionMessage(messages) {
        const randomIndex = Math.floor(Math.random() * sessionMessages.length);
        return sessionMessages[randomIndex];
    }
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }

    color: "transparent"

    Behavior on height {
        NumberAnimation {
            duration: 200 // milliseconds
            easing.type: Easing.OutCubic
        }
    }

    implicitWidth: sessionMenuColumn.width + (Theme.padding * 2)
    implicitHeight: sessionMenuColumn.height + (Theme.padding * 2)
    visible: popupOpen

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

            ColumnLayout {
                id: sessionMenuColumn

                spacing: Theme.padding
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: Theme.padding
                anchors.leftMargin: Theme.padding
                anchors.rightMargin: Theme.padding
                GridLayout {
                    id: sessionMenuGrid
                    Layout.alignment: Qt.AlignCenter
                    columnSpacing: Theme.padding * 2
                    rowSpacing: Theme.padding * 2
                    columns: 3

                    SessionMenuButton {
                        buttonIcon: "󰍃"
                        buttonText: "Logout"
                        Layout.alignment: Qt.AlignCenter
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
                        Layout.alignment: Qt.AlignCenter
                        onHoveredChanged: {
                            if (hovered)
                                root.hoveredAction = this.buttonText;
                            else
                                root.hoveredAction = root.getRandomSessionMessage();
                        }
                    }
                }

                Text {
                    id: sessionMenuText
                    Layout.alignment: Qt.AlignCenter
                    Layout.maximumWidth: sessionMenuGrid.width
                    text: root.hoveredAction
                    color: Theme.colors.subtext1
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.minimumHeight: lineHeight * 2
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.normal
                    }
                }
            }
        }
    }
}
