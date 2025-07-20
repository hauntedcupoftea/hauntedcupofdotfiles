pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.theme

// DISCLAIMER: THIS IS VERY BAD. DO NOT COPY OR LEARN FROM THIS FILE. I WILL REMOVE THIS WHEN I FEEL GOOD ABOUT HAVING THIS FILE
PopupWindow {
    id: root

    required property Rectangle anchorItem
    property QsMenuHandle menuHandle
    property QsMenuHandle previousMenu: null // TODO: this is better as a list to traverse backwards

    implicitHeight: content.height + (Theme.padding)
    implicitWidth: content.width + (Theme.padding)
    color: "transparent"

    anchor {
        item: anchorItem
        rect: Qt.rect(anchorItem.width, anchorItem.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }

    function open(handle: QsMenuHandle) {
        root.visible = true;
        root.previousMenu = null;
        root.menuHandle = handle;
    }

    QsMenuOpener {
        id: opener
        menu: root.menuHandle
    }

    MouseArea {
        id: reactiveArea
        hoverEnabled: true
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            radius: Theme.rounding.verysmall
            color: Theme.colors.base
            Rectangle {
                id: content
                color: "transparent"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: Theme.padding / 2
                implicitHeight: menuLayout.height
                implicitWidth: menuLayout.width
                Loader {
                    Layout.fillHeight: true
                    active: root.previousMenu
                    sourceComponent: Button {
                        id: backButton
                        implicitWidth: backText.width + Theme.margin
                        implicitHeight: menuLayout.height + Theme.padding
                        anchors.right: menuLayout.left
                        background: Rectangle {
                            radius: Theme.rounding.verysmall
                            color: backButton.hovered ? Theme.colors.surface0 : Theme.colors.base
                        }
                        StyledText {
                            id: backText
                            anchors.centerIn: parent
                            text: "󰅁"
                            textColor: Theme.colors.overlay0
                            font.pixelSize: Theme.font.larger
                        }
                        action: Action {
                            onTriggered: {
                                root.menuHandle = root.previousMenu;
                                root.previousMenu = null;
                            }
                        }
                    }
                }
                Rectangle {
                    color: Theme.colors.surface0
                    radius: Theme.rounding.verysmall

                    implicitHeight: menuLayout.implicitHeight
                    implicitWidth: menuLayout.implicitWidth

                    ColumnLayout {
                        id: menuLayout
                        anchors.centerIn: parent

                        Repeater {
                            id: innerMenu
                            model: opener.children.values

                            delegate: Loader {
                                id: loader
                                required property QsMenuEntry modelData
                                Component {
                                    id: separatorComponent
                                    Rectangle {
                                        implicitWidth: menuLayout.width
                                        implicitHeight: Theme.rounding.unsharpen
                                        color: Theme.colors.base
                                    }
                                }

                                Component {
                                    id: textComponent
                                    Button {
                                        id: textButton
                                        implicitWidth: textLayout.width
                                        implicitHeight: textLayout.height
                                        property bool buttonOn: loader.modelData?.enabled || false
                                        property bool hasSubMenu: loader.modelData?.hasChildren || false

                                        background: Rectangle {
                                            radius: Theme.rounding.verysmall
                                            color: textButton.hovered && textButton.buttonOn ? Theme.colors.surface2 : "transparent"
                                        }
                                        action: Action {
                                            onTriggered: {
                                                if (textButton.hasSubMenu) {
                                                    root.previousMenu = root.menuHandle;
                                                    root.menuHandle = loader.modelData; // broken
                                                } else {
                                                    loader.modelData.triggered();
                                                    root.visible = false;
                                                }
                                            }
                                        }

                                        RowLayout {
                                            id: textLayout
                                            implicitWidth: textButton.width
                                            property QsMenuEntry entry: loader.modelData

                                            function getIcon() {
                                                if (entry?.buttonType == QsMenuButtonType.CheckBox) {
                                                    if (entry.checkState == Qt.Unchecked)
                                                        return "";
                                                    return "";
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
                                                Layout.leftMargin: Theme.padding
                                                text: loader.modelData?.text || ""
                                                color: textButton.buttonOn ? Theme.colors.text : Theme.colors.surface1
                                                font.pixelSize: Theme.font.small
                                            }
                                            StyledText {
                                                Layout.alignment: Qt.AlignRight
                                                Layout.leftMargin: Theme.padding
                                                text: textLayout.getIcon()
                                                color: Theme.colors.subtext0
                                                font.pixelSize: Theme.font.small
                                            }
                                        }
                                    }
                                }

                                sourceComponent: loader.modelData.isSeparator ? separatorComponent : textComponent
                            }
                        }
                    }
                }
            }
        }
    }
}
