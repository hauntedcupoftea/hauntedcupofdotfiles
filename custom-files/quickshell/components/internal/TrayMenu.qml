pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.theme

PopupWindow {
    id: root

    required property Rectangle anchorItem
    property QsMenuOpener menuHandle: dummy
    property list<QsMenuOpener> menuStack: []  // Stack to track menu history

    implicitHeight: content.height + (Theme.padding * 2)
    implicitWidth: content.width + (Theme.padding * 2)
    color: "transparent"

    QsMenuOpener {
        id: dummy
    }

    HyprlandFocusGrab {
        active: root.visible
        windows: [root]
        onCleared: {
            root.close();
        }
    }

    anchor {
        item: anchorItem
        rect: Qt.rect(anchorItem.width, anchorItem.height, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }

    function open(handle: QsMenuOpener) {
        root.visible = true;
        root.menuStack = [];
        root.menuHandle = handle;
    }

    function pushMenu(newMenu: QsMenuOpener) {
        root.menuStack.push(root.menuHandle);
        root.menuHandle = newMenu;
    }

    function popMenu() {
        if (root.menuStack.length > 0) {
            root.menuHandle = root.menuStack.pop();
        }
    }

    function close() {
        root.menuStack = [];
        root.menuHandle = dummy;
        root.visible = false;
    }

    // DEBUG
    // onMenuStackChanged: {
    //     print(menuStack);
    // }

    MouseArea {
        id: reactiveArea
        hoverEnabled: true
        anchors.fill: parent
        // TODO: needs better close policies than this
        // onHoveredChanged: {
        //     if (!reactiveArea.containsMouse)
        //         root.visible = false;
        // }

        Rectangle {
            id: content
            anchors.centerIn: parent
            radius: Theme.rounding.small
            color: Theme.colors.surface_container_high
            border.width: 1
            border.color: Theme.colors.outline

            implicitWidth: Math.max(menuLayout.implicitWidth, backButton.visible ? backButton.implicitWidth : 0) + (Theme.padding * 2)
            implicitHeight: menuLayout.implicitHeight + (backButton.visible ? backButton.implicitHeight + Theme.padding / 2 : 0) + (Theme.padding * 2)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.padding
                spacing: Theme.padding / 2

                // Back button at the top when there's menu history
                Button {
                    id: backButton
                    visible: root.menuStack.length > 0
                    Layout.fillWidth: true
                    implicitHeight: Theme.font.normal + Theme.padding
                    background: Rectangle {
                        radius: Theme.rounding.small
                        color: backButton.hovered ? Theme.colors.surface_container : Theme.colors.surface
                        border.width: 1
                        border.color: backButton.hovered ? Theme.colors.surface_container_high : Theme.colors.surface_container
                    }

                    contentItem: RowLayout {
                        spacing: Theme.padding / 2

                        StyledText {
                            text: "󰅁"
                            color: Theme.colors.on_surface_variant
                            font.pixelSize: Theme.font.normal
                        }

                        StyledText {
                            text: "Back"
                            color: Theme.colors.on_surface
                            font.pixelSize: Theme.font.small
                            Layout.fillWidth: true
                        }
                    }

                    onClicked: root.popMenu()
                }

                // Separator between back button and menu items
                Rectangle {
                    visible: backButton.visible
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Theme.colors.surface_container
                }

                // Main menu content
                ColumnLayout {
                    id: menuLayout
                    Layout.fillWidth: true
                    spacing: 0

                    Repeater {
                        id: innerMenu
                        model: ScriptModel {
                            // NOTE: this throws null for a brief moment when the opener is swapped.
                            //       i do not know how to handle it (|| []) break it because it doens't update
                            values: root.menuHandle && root.menuHandle.children.values // qmllint disable
                        }

                        delegate: Loader {
                            id: loader
                            required property QsMenuEntry modelData
                            Layout.fillWidth: true

                            QsMenuOpener {
                                id: subMenu
                                menu: loader.modelData
                            }

                            Component {
                                id: separatorComponent
                                Rectangle {
                                    Layout.fillWidth: true
                                    implicitHeight: Theme.padding / 4
                                    Layout.topMargin: Theme.padding / 4
                                    Layout.bottomMargin: Theme.padding / 4
                                    color: Theme.colors.surface_container
                                }
                            }

                            Component {
                                id: textComponent
                                Button {
                                    id: textButton
                                    Layout.fillWidth: true
                                    implicitHeight: Math.max(textLayout.implicitHeight, Theme.font.normal + Theme.padding)

                                    property bool buttonOn: loader.modelData?.enabled || false
                                    property bool hasSubMenu: loader.modelData?.hasChildren || false

                                    background: Rectangle {
                                        radius: Theme.rounding.small
                                        color: {
                                            if (!textButton.buttonOn)
                                                return "transparent";
                                            if (textButton.pressed)
                                                return Theme.colors.surface_container_high;
                                            if (textButton.hovered)
                                                return Theme.colors.surface_container;
                                            return "transparent";
                                        }
                                        border.width: textButton.hovered && textButton.buttonOn ? 1 : 0
                                        border.color: Theme.colors.surface_container_high
                                    }

                                    onClicked: {
                                        if (textButton.hasSubMenu) {
                                            root.pushMenu(subMenu);
                                        } else {
                                            loader.modelData.triggered();
                                            root.close();
                                        }
                                    }

                                    contentItem: RowLayout {
                                        id: textLayout
                                        spacing: Theme.padding

                                        property QsMenuEntry entry: loader.modelData

                                        function getIcon() {
                                            if (entry?.buttonType == QsMenuButtonType.CheckBox) {
                                                if (entry.checkState == Qt.Unchecked)
                                                    return "󰄱";
                                                return "󰱒";
                                            }
                                            if (entry?.buttonType == QsMenuButtonType.RadioButton) {
                                                if (entry.checkState == Qt.Checked)
                                                    return "󰐾";
                                                return "󰄰";
                                            }
                                            if (entry?.hasChildren)
                                                return "󰅂";
                                            return "";
                                        }

                                        StyledText {
                                            Layout.fillWidth: true
                                            Layout.leftMargin: Theme.padding / 2
                                            text: loader.modelData?.text || ""
                                            color: textButton.buttonOn ? Theme.colors.on_surface : Theme.colors.on_surface_variant
                                            font.pixelSize: Theme.font.small
                                        }

                                        StyledText {
                                            Layout.rightMargin: Theme.padding / 2
                                            text: textLayout.getIcon()
                                            color: textButton.buttonOn ? Theme.colors.on_surface_variant : Theme.colors.on_surface_variant
                                            font.pixelSize: Theme.font.small
                                        }
                                    }
                                }
                            }

                            sourceComponent: loader.modelData?.isSeparator ? separatorComponent : textComponent
                        }
                    }
                }
            }
        }
    }
}
