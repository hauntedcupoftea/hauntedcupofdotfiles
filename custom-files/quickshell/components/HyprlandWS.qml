import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../theme"
import "../config"
import "internal" as Private

Rectangle {
    radius: Theme.rounding.small
    implicitWidth: hyprlandRow.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)
    color: Theme.colors.crust
    RowLayout {
        id: hyprlandRow
        anchors.centerIn: parent
        spacing: Theme.margin
        Repeater {
            model: Hyprland.workspaces.values.filter(workspace => workspace.id >= 0)
            Button {
                id: workspaceButton
                required property HyprlandWorkspace modelData
                implicitHeight: Theme.barHeight - (Theme.margin * 2)
                implicitWidth: Theme.barHeight

                property real fillPercentage: {
                    const windowCount = workspaceButton.modelData.toplevels ? (workspaceButton.modelData.toplevels.values ? workspaceButton.modelData.toplevels.values.length : 0) : 0;
                    const threshold = Settings.windowsThreshold || 1;
                    if (modelData.hasFullscreen)
                        return 1;
                    return Math.min(windowCount / threshold, 1.0);
                }

                function getBgColor() {
                    if (modelData.urgent && urgencyFlash.flashOn) {
                        return Theme.colors.flamingo;
                    }

                    if (modelData.focused)
                        return Theme.colors.surface2;
                    if (modelData.active)
                        return Theme.colors.surface1;
                    return Theme.colors.mantle;
                }

                function getFillColor() {
                    if (modelData.urgent && urgencyFlash.flashOn) {
                        return Theme.colors.red;
                    }

                    if (modelData.focused) {
                        return Theme.colors.blue;
                    } else if (modelData.active) {
                        return Theme.colors.sky;
                    } else {
                        return Theme.colors.rosewater;
                    }
                }

                // DEBUG
                // Component.onCompleted: {
                //     console.log("Workspace:", workspaceButton.modelData.name, "Windows:", workspaceButton.modelData.toplevels?.values?.length || 0, "Fill:", fillPercentage, "Active:", modelData.active, "Focused:", modelData.focused);
                // }

                Timer {
                    id: urgencyFlash
                    interval: 600
                    repeat: true
                    running: workspaceButton.modelData.urgent

                    property bool flashOn: false

                    onTriggered: {
                        flashOn = !flashOn;
                    }

                    onRunningChanged: {
                        if (!running) {
                            flashOn = false;
                        }
                    }
                }

                background: ClippingRectangle {
                    radius: Theme.rounding.full
                    color: workspaceButton.hovered ? Theme.colors.surface0 : workspaceButton.getBgColor()

                    // Smooth color transitions
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height * workspaceButton.fillPercentage
                        color: workspaceButton.hovered ? Theme.colors.maroon : workspaceButton.getFillColor()

                        // Smooth transitions for fill
                        Behavior on height {
                            NumberAnimation {
                                duration: 250
                                easing.type: Easing.OutQuad
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }

                Private.StyledText {
                    text: workspaceButton.modelData.id
                    anchors.centerIn: parent
                    color: {
                        if (workspaceButton.modelData.urgent && urgencyFlash.flashOn) {
                            return workspaceButton.fillPercentage > 0.5 ? Theme.colors.flamingo : Theme.colors.overlay0;
                        }
                        if (workspaceButton.fillPercentage > 0.5)
                            return Theme.colors.surface0;
                        return Theme.colors.text;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }
                }

                action: Action {
                    id: goToWorkspace
                    onTriggered: {
                        workspaceButton.modelData.activate();
                    }
                }

                // i don't even know if i want a popup here. what would it even say?
                // Private.ToolTipPopup {
                //     expandDirection: Edges.Bottom
                //     targetWidget: workspaceButton
                //     triggerTarget: true
                //     position: Qt.rect(workspaceButton.width / 2, workspaceButton.height + Theme.padding, 0, 0)

                //     Private.StyledText {
                //         text: "pee pee\npoo poo"
                //         color: Theme.colors.subtext1
                //     }
                // }
            }
        }
    }
}
