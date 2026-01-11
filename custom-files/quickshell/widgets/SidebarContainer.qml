pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import qs.theme
import qs.sidebar

PopupWindow {
    id: container

    property var barGroup
    property var anchorItem
    property var gravity
    property rect position
    required property string sidebarTitle
    required property real screenHeight
    required property real screenWidth

    color: "transparent"

    readonly property int idealWidth: {
        const baseWidth = Math.min(screenWidth * 0.4, 900);
        const minWidth = 500;
        const maxWidth = 1000;

        return Math.max(minWidth, Math.min(baseWidth, maxWidth));
    }

    readonly property int idealHeight: {
        const headerHeight = Theme.barHeight + (Theme.padding * 2);
        const availableHeight = screenHeight - headerHeight - (Theme.padding * 4);

        return Math.min(availableHeight, screenHeight * 0.92);
    }

    implicitWidth: idealWidth
    implicitHeight: idealHeight

    anchor {
        item: anchorItem
        rect: position
        gravity: gravity
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.colors.surface_container
        radius: Theme.rounding.normal
        border.width: 1
        border.color: Theme.colors.outline_variant

        scale: container.visible ? 1.0 : 0.95
        opacity: container.visible ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: Theme.anims.duration.normal
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.anims.duration.normal
                easing.type: Easing.OutCubic
            }
        }
    }

    HyprlandFocusGrab {
        active: container.visible
        windows: [container]
        onCleared: container.visible = false
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.barHeight + (Theme.padding * 2)
        color: Theme.colors.surface_container_high
        radius: Theme.rounding.normal

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.rounding.normal
            color: parent.color
        }

        Text {
            anchors.centerIn: parent
            text: container.sidebarTitle
            font.pixelSize: Theme.font.large
            font.weight: Font.DemiBold
            color: Theme.colors.on_surface
        }

        Button {
            id: closeButton
            anchors.right: parent.right
            anchors.rightMargin: Theme.padding
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.barHeight
            height: Theme.barHeight

            background: Rectangle {
                color: closeButton.hovered ? Theme.colors.error_container : Theme.colors.surface_container_low
                radius: Theme.rounding.small

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anims.duration.small
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "󰅖"
                font.pixelSize: Theme.font.large
                color: closeButton.hovered ? Theme.colors.on_error_container : Theme.colors.on_surface

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anims.duration.small
                    }
                }
            }

            onClicked: container.visible = false
        }
    }

    ListView {
        id: contentRepeater
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Theme.padding

        spacing: Theme.padding
        clip: true

        model: container.barGroup ? container.barGroup.sidebarComponents : []

        delegate: Loader {
            id: delegateLoader
            width: contentRepeater.width
            required property string modelData

            readonly property int componentHeight: {
                switch (modelData) {
                case "notification-manager":
                    return Math.max(400, container.idealHeight * 0.6);
                case "calendar":
                    return Math.min(600, container.idealHeight - (Theme.padding * 2));
                case "session-menu":
                    return 180;
                case "battery-menu":
                    return 200;
                case "connectivity-menu":
                    return 300;
                default:
                    return 120;
                }
            }

            height: componentHeight

            sourceComponent: {
                switch (modelData) {
                case "notification-manager":
                    return notificationManagerComponent;
                case "session-menu":
                    return sessionMenuComponent;
                case "calendar":
                    return calendarComponent;
                case "battery-menu":
                    return batteryMenuComponent;
                case "connectivity-menu":
                    return connectivityMenuComponent;
                case "to-do":
                    return todoComponent;
                default:
                    return placeholderComponent;
                }
            }
        }
    }

    Component {
        id: notificationManagerComponent
        NotificationManager {
            anchors.fill: parent
        }
    }

    Component {
        id: sessionMenuComponent
        SessionMenu {
            anchors.fill: parent
        }
    }

    Component {
        id: calendarComponent
        Calendar {
            anchors.fill: parent
        }
    }

    Component {
        id: batteryMenuComponent
        Rectangle {
            color: Theme.colors.primary_container
            radius: Theme.rounding.verysmall
            border {
                width: 1
                color: Theme.colors.outline_variant
            }
            Text {
                anchors.centerIn: parent
                text: "Battery Menu (WIP)"
                color: Theme.colors.on_primary_container
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                }
            }
        }
    }

    Component {
        id: connectivityMenuComponent
        Rectangle {
            color: Theme.colors.secondary_container
            radius: Theme.rounding.verysmall
            border {
                width: 1
                color: Theme.colors.outline_variant
            }
            Text {
                anchors.centerIn: parent
                text: "Connectivity Menu (WIP)"
                color: Theme.colors.on_secondary_container
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                }
            }
        }
    }

    Component {
        id: todoComponent
        Rectangle {
            color: Theme.colors.tertiary_container
            radius: Theme.rounding.verysmall
            border {
                width: 1
                color: Theme.colors.outline_variant
            }
            Text {
                anchors.centerIn: parent
                text: "To-Do (WIP)"
                color: Theme.colors.on_tertiary_container
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                }
            }
        }
    }

    Component {
        id: placeholderComponent
        Rectangle {
            color: Theme.colors.error_container
            radius: Theme.rounding.verysmall
            border {
                width: 1
                color: Theme.colors.outline_variant
            }
            Text {
                anchors.centerIn: parent
                text: "Unknown Component"
                color: Theme.colors.on_error_container
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                }
            }
        }
    }
}
