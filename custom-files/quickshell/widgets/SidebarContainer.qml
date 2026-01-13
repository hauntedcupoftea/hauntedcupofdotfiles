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

        scale: container.visible ? 1.0 : 0.90
        opacity: container.visible ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.anims.curve.emphasizedDecel
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
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
        anchors.margins: Theme.padding
        height: Theme.barHeight - Theme.margin
        color: Theme.colors.surface_container_high
        radius: Theme.rounding.small

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
            anchors.rightMargin: Theme.margin
            anchors.verticalCenter: parent.verticalCenter
            width: parent.height - Theme.margin
            height: parent.height - Theme.margin

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

        visible: bg.opacity > 0.95
        clip: true

        model: container.barGroup ? container.barGroup.sidebarComponents : []

        delegate: Loader {
            id: delegateLoader
            required property var modelData
            required property int index

            width: contentRepeater.width

            property real itemOpacity: 1.0
            property real itemScale: 1.0

            opacity: itemOpacity
            scale: itemScale

            transformOrigin: Item.Center

            sourceComponent: {
                switch (modelData) {
                case "notification-manager":
                    return notifComponent;
                case "session-menu":
                    return sessionComponent;
                case "calendar":
                    return calendarComponent;
                case "battery-menu":
                    return batteryComponent;
                case "connectivity-menu":
                    return connectivityComponent;
                case "to-do":
                    return todoComponent;
                default:
                    return null;
                }
            }

            Component {
                id: notifComponent
                NotificationManager {
                    height: contentRepeater.height * 0.7
                    width: contentRepeater.width
                }
            }

            Component {
                id: sessionComponent
                SessionMenu {
                    height: 150
                    width: contentRepeater.width
                }
            }

            Component {
                id: calendarComponent
                Calendar {
                    height: 500 + (Theme.margin * 2)
                    width: contentRepeater.width
                }
            }

            Component {
                id: batteryComponent
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

            Component {
                id: connectivityComponent
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

            Component {
                id: todoComponent
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

        add: Transition {
            SequentialAnimation {
                PropertyAction {
                    property: "itemOpacity"
                    value: 0
                }
                PropertyAction {
                    property: "itemScale"
                    value: 0.8
                }
                PauseAnimation {
                    duration: 40 * (ViewTransition.index || 0)
                }
                ParallelAnimation {
                    NumberAnimation {
                        property: "itemOpacity"
                        to: 1.0
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        property: "itemScale"
                        to: 1.0
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.2
                    }
                }
            }
        }

        remove: Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        property: "itemOpacity"
                        to: 0
                        duration: 120
                        easing.type: Easing.InQuad
                    }
                    NumberAnimation {
                        property: "itemScale"
                        to: 0.8
                        duration: 120
                        easing.type: Easing.InQuad
                    }
                }
                PropertyAction {
                    property: "height"
                    value: 0
                }
            }
        }

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }

    onVisibleChanged: {
        if (!visible && barGroup.sidebarOpen) {
            barGroup.sidebarOpen = false;
        }
    }
}
