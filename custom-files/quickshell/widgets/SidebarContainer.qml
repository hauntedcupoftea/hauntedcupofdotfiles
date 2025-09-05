pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
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
        height: 40
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
            width: 24
            height: 24

            background: Rectangle {
                color: closeButton.hovered ? Theme.colors.error_container : "transparent"
                radius: Theme.rounding.small
            }

            Text {
                anchors.centerIn: parent
                text: "×"
                font.pixelSize: Theme.font.normal
                color: closeButton.hovered ? Theme.colors.on_error_container : Theme.colors.on_surface
            }

            onClicked: container.visible = false
        }
    }

    // Content area // TODO: replace with delegatechooser
    // ListView {
    //     id: contentRepeater
    //     anchors.top: header.bottom
    //     anchors.bottom: parent.bottom
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     anchors.margins: Theme.padding
    //     model: container.barGroup ? container.barGroup.sidebarComponents : []
    // }
    //
    ColumnLayout {
        anchors.top: header.bottom
        anchors.bottom: bg.bottom
        anchors.left: bg.left
        anchors.right: bg.right
        anchors.margins: Theme.padding
        NotificationManager {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        SessionMenu {
            Layout.minimumHeight: 150
            Layout.fillWidth: true
        }
    }

    // function rebuildContent() {
    //     // Force model refresh
    //     let oldModel = contentRepeater.model;
    //     contentRepeater.model = null;
    //     contentRepeater.model = oldModel;
    // }

    // Debug: Log when visibility changes
    onVisibleChanged: {
        console.log("SidebarContainer visibility changed:", visible, "for", sidebarTitle);
        if (visible) {
            console.log("Components registered:", barGroup ? barGroup.sidebarComponents.length : 0);
            console.info(barGroup.sidebarComponents);
        }
    }
}
