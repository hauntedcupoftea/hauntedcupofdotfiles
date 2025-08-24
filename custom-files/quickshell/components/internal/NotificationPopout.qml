import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.theme
import qs.config
import qs.services

PopupWindow {
    id: root
    required property var powerButton
    required property bool popupOpen

    implicitWidth: Settings.notificationWidth + (Theme.padding * 2)
    implicitHeight: 600

    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Left // qmllint disable
    }
    color: "transparent"

    Behavior on height {
        NumberAnimation {
            duration: 200 // milliseconds
            easing.type: Easing.OutCubic
        }
    }

    HyprlandFocusGrab {
        active: root.visible
        windows: [root]
        onCleared: {
            root.powerButton.action.trigger();
        }
    }

    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container_high
        border {
            width: 1
            color: Theme.colors.outline
        }

        ListView {
            id: notificationList

            anchors.fill: parent
            anchors.margins: Theme.padding
            spacing: Theme.padding
            model: Notify.items
            orientation: ListView.Vertical

            header: RowLayout {
                implicitWidth: Settings.notificationWidth

                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: "Notifications"
                    font.weight: Font.Medium
                    color: Theme.colors.on_surface_variant
                    font.pixelSize: Theme.font.larger
                }

                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: clearAllText.implicitWidth + Theme.padding * 2
                    radius: Theme.rounding.small
                    color: clearAllMouseArea.containsMouse ? Theme.colors.secondary : Theme.colors.secondary_container
                    border.width: 1
                    border.color: clearAllMouseArea.containsMouse ? Theme.colors.error : Theme.colors.outline_variant

                    StyledText {
                        id: clearAllText
                        anchors.centerIn: parent
                        text: "󰆴 Clear All"
                        font.pixelSize: Theme.font.small
                        color: clearAllMouseArea.containsMouse ? Theme.colors.on_secondary : Theme.colors.on_secondary_container
                    }

                    MouseArea {
                        id: clearAllMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Notify.clearNotifications();
                        }
                    }
                }
            }
            delegate: NotificationCard {
                required property var modelData
                required property int index

                n: modelData
            }

            add: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "height"
                        from: 0
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 0.8
                        to: 1
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "height"
                        to: 0
                        duration: 200
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 150
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        property: "scale"
                        to: 0.8
                        duration: 200
                        easing.type: Easing.InCubic
                    }
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
        ColumnLayout {
            anchors.centerIn: parent
            visible: Notify.items.length === 0
            spacing: Theme.padding

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: "󰂜"
                font.pixelSize: 48
                color: Theme.colors.on_surface_variant
                opacity: 0.4
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "No notifications"
                color: Theme.colors.on_surface_variant
                opacity: 0.6
                font.pixelSize: Theme.font.normal
            }
        }
    }
}
