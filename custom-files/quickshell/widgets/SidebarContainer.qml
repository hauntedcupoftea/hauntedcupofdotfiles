pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import qs.theme

PopupWindow {
    id: container

    property var barGroup
    required property string sidebarTitle
    required property real screenHeight
    required property real screenWidth
    color: "transparent"

    implicitWidth: screenWidth / 5
    implicitHeight: screenHeight

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.colors.surface_container
        radius: Theme.rounding.normal
        border.width: 1
        border.color: Theme.colors.outline_variant
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

        // Close button
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

    // Content area
    ScrollView {
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Theme.padding

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.padding

            Repeater {
                id: contentRepeater
                model: container.barGroup ? container.barGroup.sidebarComponents : []

                delegate: Item {
                    id: sidebarItem
                    width: contentColumn.width
                    height: sectionLoader.item ? sectionLoader.implicitHeight : 0
                    required property var modelData

                    Rectangle {
                        id: sectionHeader
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: sidebarItem.modelData.sidebarTitle ? 30 : 0
                        visible: sidebarItem.modelData.sidebarTitle !== undefined
                        color: Theme.colors.surface_variant
                        radius: Theme.rounding.small

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.padding
                            anchors.verticalCenter: parent.verticalCenter
                            text: sidebarItem.modelData.sidebarTitle || ""
                            font.pixelSize: Theme.font.normal
                            font.weight: 500
                            color: Theme.colors.on_surface_variant
                        }
                    }

                    // Component content
                    Loader {
                        id: sectionLoader
                        anchors.top: sectionHeader.bottom
                        anchors.topMargin: sectionHeader.visible ? Theme.padding / 2 : 0
                        anchors.left: parent.left
                        anchors.right: parent.right

                        sourceComponent: sidebarItem.modelData.sidebarComponent

                        onLoaded: {
                            // Pass sidebarData to the loaded component
                            if (item && sidebarItem.modelData.sidebarData) {
                                for (let key in sidebarItem.modelData.sidebarData) {
                                    if (item.hasOwnProperty(key)) {
                                        item[key] = sidebarItem.modelData.sidebarData[key];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function getSidebarTitle() {
        switch (position) {
        case "left":
            return "System & Session";
        case "right":
            return "Status & Notifications";
        case "center":
            return "Media & Volume";
        default:
            return "Controls";
        }
    }

    function rebuildContent() {
        // Force model refresh
        contentRepeater.model = null;
        contentRepeater.model = barGroup ? barGroup.sidebarComponents : [];
    }
}
