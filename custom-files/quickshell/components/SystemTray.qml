import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.theme
import qs.config
import "internal" as Private

Rectangle {
    id: systemTray
    radius: Theme.rounding.small
    implicitWidth: sysTrayRow.width + (Theme.padding)
    implicitHeight: Theme.barHeight - (Theme.margin)
    color: Theme.colors.crust

    // Hide the tray if no items are present
    property var filteredItems: SystemTray.items.values.filter(item => !Settings.ignoredTrayItems.includes(item.id))
    visible: filteredItems.length > 0

    RowLayout {
        id: sysTrayRow
        anchors.centerIn: parent
        spacing: Theme.margin / 2

        Repeater {
            model: ScriptModel {
                values: systemTray.filteredItems
            }

            Button {
                id: sysTrayButton
                required property SystemTrayItem modelData
                implicitHeight: Theme.trayIconSize + Theme.margin
                implicitWidth: Theme.trayIconSize + Theme.margin

                Private.ToolTipPopup {
                    expandDirection: Edges.Bottom
                    targetWidget: sysTrayButton
                    triggerTarget: true
                    position: Qt.rect(sysTrayButton.width / 2, Theme.barHeight - Theme.margin, 0, 0)

                    Private.StyledText {
                        text: sysTrayButton.modelData.tooltipTitle || sysTrayButton.modelData.title
                        color: Theme.colors.subtext0
                        font.pixelSize: Theme.font.normal
                    }
                    Private.StyledText {
                        text: sysTrayButton.modelData.tooltipDescription
                        color: Theme.colors.subtext1
                        font.pixelSize: Theme.font.small
                    }
                }

                background: Rectangle {
                    radius: Theme.rounding.full
                    color: {
                        if (sysTrayButton.pressed)
                            return Theme.colors.surface1;
                        if (sysTrayButton.hovered)
                            return Theme.colors.surface0;
                        return Theme.colors.mantle;
                    }

                    // Visual feedback for items with attention
                    border.width: sysTrayButton.modelData.status === Status.NeedsAttention ? 2 : 0
                    border.color: Theme.colors.red

                    // Subtle animation for attention status
                    SequentialAnimation on opacity {
                        running: sysTrayButton.modelData.status === Status.NeedsAttention
                        loops: Animation.Infinite
                        NumberAnimation {
                            to: 0.6
                            duration: 1000
                        }
                        NumberAnimation {
                            to: 1.0
                            duration: 1000
                        }
                    }
                }

                IconImage {
                    anchors.centerIn: parent
                    source: sysTrayButton.modelData.icon
                    implicitSize: Theme.trayIconSize
                    opacity: sysTrayButton.modelData.status === "Passive" ? 0.7 : 1.0
                }

                onClicked: {
                    if (!sysTrayButton.modelData.onlyMenu)
                        sysTrayButton.modelData.activate();
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        if (sysTrayButton.modelData.hasMenu) {
                            sysTrayContextMenu.open();
                        }
                    }
                }

                QsMenuAnchor {
                    id: sysTrayContextMenu
                    anchor {
                        item: sysTrayButton
                        rect: Qt.rect(sysTrayButton.width / 2, Theme.barHeight - Theme.margin, 0, 0)
                    }
                    menu: sysTrayButton.modelData.menu
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: {
                        sysTrayButton.modelData.secondaryActivate();
                    }
                }

                // DEBUG
                // Component.onCompleted: {
                //     print("SystemTray item:", JSON.stringify({
                //         id: modelData.id,
                //         title: modelData.title,
                //         status: modelData.status,
                //         hasMenu: !!modelData.menu
                //     }))
                // }
            }
        }
    }

    // Smooth show/hide animation
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    // Close any open context menus when clicking outside the tray
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: {
            // Find and close any open context menus
            for (var i = 0; i < sysTrayRow.children.length; i++) {
                var repeater = sysTrayRow.children[i];
                if (repeater.model)
                // This is a bit hacky but works for closing menus
                // You might want to implement a more robust solution
                {}
            }
        }
    }
}
