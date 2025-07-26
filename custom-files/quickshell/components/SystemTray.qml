pragma ComponentBehavior: Bound

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
    color: Theme.colors.surface_container

    property var filteredItems: SystemTray.items.values.filter(item => !Settings.ignoredTrayItems.includes(item.id))
    visible: filteredItems.length > 0

    signal requestOpen

    function forceClose() {
        trayMenu.close();
    }

    RowLayout {
        id: sysTrayRow
        anchors.centerIn: parent
        spacing: Theme.margin / 2

        // universal pop-up
        Private.TrayMenu {
            id: trayMenu
            anchorItem: systemTray
        }

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
                    blockShow: trayMenu.visible

                    Private.StyledText {
                        text: sysTrayButton.modelData?.tooltipTitle || sysTrayButton.modelData?.title || ""
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.normal
                    }
                    Private.StyledText {
                        text: sysTrayButton.modelData?.tooltipDescription ?? ""
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.small
                    }
                }

                background: Rectangle {
                    radius: Theme.rounding.full
                    color: {
                        if (sysTrayButton.pressed)
                            return Theme.colors.surface_container_highest;
                        if (sysTrayButton.hovered)
                            return Theme.colors.surface_container_high;
                        return Theme.colors.surface_container;
                    }

                    border.width: sysTrayButton.modelData?.status === Status.NeedsAttention ? 2 : 0
                    border.color: Theme.colors.error

                    SequentialAnimation on opacity {
                        running: sysTrayButton.modelData?.status === Status.NeedsAttention
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
                    source: sysTrayButton.modelData && sysTrayButton.modelData.icon
                    implicitSize: Theme.trayIconSize
                    opacity: sysTrayButton.modelData?.status === "Passive" ? 0.7 : 1.0
                }

                onClicked: {
                    if (!sysTrayButton.modelData.onlyMenu)
                        sysTrayButton.modelData.activate();
                }

                QsMenuOpener {
                    id: traySubMenu
                    menu: sysTrayButton.modelData && sysTrayButton.modelData.menu
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        if (sysTrayButton.modelData.hasMenu) {
                            systemTray.requestOpen();
                            trayMenu.open(traySubMenu);
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: {
                        sysTrayButton.modelData.secondaryActivate();
                    }
                }
            }
        }
    }
}
