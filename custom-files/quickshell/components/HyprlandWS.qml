pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import qs.theme
import qs.config
import "internal" as Private

Rectangle {
    radius: Theme.rounding.pillMedium
    implicitWidth: hyprlandRow.width + Theme.padding * 2
    implicitHeight: Theme.barHeight - Theme.margin

    color: Theme.colors.surface_container

    border.width: 2
    border.color: Qt.alpha(Theme.colors.outline, 0.3)

    RowLayout {
        id: hyprlandRow
        anchors.centerIn: parent
        spacing: Theme.margin

        Repeater {
            model: ScriptModel {
                values: Hyprland.workspaces.values.filter(workspace => workspace.id >= 0)
            }

            Button {
                id: workspaceButton
                required property HyprlandWorkspace modelData
                implicitHeight: Theme.barHeight - Theme.margin * 2
                implicitWidth: Theme.barHeight

                property real fillPercentage: {
                    const windowCount = workspaceButton.modelData.toplevels ? (workspaceButton.modelData.toplevels.values ? workspaceButton.modelData.toplevels.values.length : 0) : 0;
                    if (modelData.hasFullscreen)
                        return 1;
                    return windowCount / (windowCount + 1);
                }

                function getBgColor() {
                    if (modelData.urgent && urgencyFlash.flashOn) {
                        return Theme.colors.error_container;
                    }
                    if (modelData.focused)
                        return Theme.colors.primary_container;
                    if (modelData.active)
                        return Theme.colors.secondary_container;
                    return Theme.colors.surface_container_low;
                }

                function getFillColor() {
                    if (modelData.urgent && urgencyFlash.flashOn) {
                        return Theme.colors.error;
                    }
                    if (modelData.focused) {
                        return Theme.colors.primary;
                    } else if (modelData.active) {
                        return Theme.colors.secondary;
                    } else {
                        return Theme.colors.tertiary;
                    }
                }

                Timer {
                    id: urgencyFlash
                    interval: Theme.anims.duration.large
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
                    radius: Theme.rounding.small

                    color: workspaceButton.getBgColor()

                    Behavior on border.color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
                            easing.type: Easing.OutQuad
                        }
                    }

                    Rectangle {
                        id: fillRect
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height * workspaceButton.fillPercentage

                        color: workspaceButton.getFillColor()

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.anims.duration.normal
                                easing.type: Easing.OutBack
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                                easing.type: Easing.OutQuad
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            height: 2
                            visible: workspaceButton.fillPercentage > 0.05
                            color: Qt.lighter(parent.color, 1.3)
                            opacity: 0.8

                            SequentialAnimation on opacity {
                                running: workspaceButton.modelData.active || workspaceButton.modelData.focused
                                loops: Animation.Infinite
                                NumberAnimation {
                                    to: 0.3
                                    duration: 1500
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    to: 0.8
                                    duration: 1500
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }

                Private.StyledText {
                    text: workspaceButton.modelData.id
                    anchors.centerIn: parent
                    color: {
                        if (workspaceButton.modelData.urgent && urgencyFlash.flashOn) {
                            return Theme.colors.on_error_container;
                        }
                        if (workspaceButton.modelData.focused) {
                            return Theme.colors.on_primary;
                        }
                        if (workspaceButton.modelData.active) {
                            return Theme.colors.on_secondary_container;
                        }
                        if (workspaceButton.fillPercentage >= 0.5)
                            return Theme.colors.on_primary;
                        return Theme.colors.on_surface;
                    }

                    font.weight: workspaceButton.hovered ? 800 : 400
                    font.pixelSize: Theme.font.small

                    layer.enabled: true
                    layer.smooth: true
                    layer.textureSize: Qt.size(width * 2, height * 2)

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
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
            }
        }
    }
}
