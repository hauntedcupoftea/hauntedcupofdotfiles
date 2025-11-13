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
    required property real widthRatio
    required property real heightRatio
    color: "transparent"

    implicitWidth: screenWidth * widthRatio
    implicitHeight: screenHeight * heightRatio

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

        // Behavior on scale {
        //     NumberAnimation {
        //         duration: 200
        //         easing.type: Easing.OutCubic
        //     }
        // }

        // Behavior on opacity {
        //     NumberAnimation {
        //         duration: 200
        //         easing.type: Easing.OutCubic
        //     }
        // }
    }

    // Focus management
    HyprlandFocusGrab {
        active: container.visible
        windows: [container]
        onCleared: container.visible = false
    }

    // Header
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.barHeight
        color: Theme.colors.surface_container_high
        radius: Theme.rounding.normal

        Text {
            anchors.centerIn: parent
            text: container.sidebarTitle
            font.pixelSize: Theme.font.large
            font.weight: 600
            color: Theme.colors.on_surface
        }

        Button {
            id: closeButton
            anchors.right: parent.right
            anchors.rightMargin: Theme.padding
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.barHeight - Theme.padding
            height: Theme.barHeight - Theme.padding

            background: Rectangle {
                color: closeButton.hovered ? Theme.colors.error_container : Theme.colors.surface_container_low
                radius: Theme.rounding.small
            }

            Text {
                anchors.centerIn: parent
                text: "󰅖"
                font.pixelSize: Theme.font.large
                color: closeButton.hovered ? Theme.colors.on_error_container : Theme.colors.on_surface
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

        model: container.barGroup ? container.barGroup.sidebarComponents : []
        delegate: DelegateChooser {
            DelegateChoice {
                roleValue: "notification-manager"
                NotificationManager {
                    height: contentRepeater.height * 0.7
                    width: contentRepeater.width
                }
            }
            DelegateChoice {
                roleValue: "session-menu"
                SessionMenu {
                    height: 150
                    width: contentRepeater.width
                }
            }
            DelegateChoice {
                roleValue: "calendar"
                Calendar {
                    height: 400 + (Theme.margin * 2)
                    width: contentRepeater.width
                }
            }
            DelegateChoice {
                roleValue: "battery-menu"
                Rectangle {
                    height: 120
                    width: contentRepeater.width
                    color: Theme.colors.primary_container
                    radius: Theme.rounding.verysmall
                    Text {
                        anchors.centerIn: parent
                        text: "battery-menu placeholder"
                        color: Theme.colors.on_primary_container
                    }
                }
            }
            DelegateChoice {
                roleValue: "connectivity-menu"
                Rectangle {
                    height: 120
                    width: contentRepeater.width
                    color: Theme.colors.secondary_container
                    radius: Theme.rounding.verysmall
                    Text {
                        anchors.centerIn: parent
                        text: "connectivity-menu placeholder"
                        color: Theme.colors.on_secondary_container
                    }
                }
            }
            DelegateChoice {
                roleValue: "to-do"
                Rectangle {
                    height: 120
                    width: contentRepeater.width
                    color: Theme.colors.tertiary_container
                    radius: Theme.rounding.verysmall
                    Text {
                        anchors.centerIn: parent
                        text: "to-do placeholder"
                        color: Theme.colors.on_tertiary_container
                    }
                }
            }
        }
    }

    // Debug: Log when visibility changes
    // onVisibleChanged: {
    //     console.log("SidebarContainer visibility changed:", visible, "for", sidebarTitle);
    //     if (visible) {
    //         console.log("Components registered:", barGroup ? barGroup.sidebarComponents.length : 0);
    //         console.info(barGroup.sidebarComponents);
    //     }
    // }
}
