pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland

import qs.theme

Rectangle {
    id: root

    radius: Theme.rounding.pillMedium
    implicitWidth: hyprlandRow.width + Theme.padding * 2
    implicitHeight: Theme.barHeight - Theme.margin

    color: Theme.colors.surface_container_low
    border.width: 2
    border.color: Qt.alpha(Theme.colors.outline, 0.3)

    RowLayout {
        id: hyprlandRow
        anchors.centerIn: parent
        spacing: Theme.margin / 2

        Repeater {
            model: ScriptModel {
                values: Hyprland.workspaces.values.filter(workspace => workspace.id >= 0).sort((a, b) => a.id - b.id)
            }

            Button {
                id: workspaceButton
                required property HyprlandWorkspace modelData

                implicitHeight: root.height - Theme.margin
                implicitWidth: Theme.barHeight

                readonly property bool isFocused: modelData.focused
                readonly property bool isActive: modelData.active
                readonly property bool isUrgent: modelData.urgent
                readonly property int windowCount: modelData.toplevels.values.length

                readonly property color accentColor: {
                    if (isUrgent)
                        return Theme.colors.error;
                    if (isFocused)
                        return Theme.colors.primary;
                    if (isActive)
                        return Theme.colors.tertiary;
                    return Theme.colors.secondary;
                }

                readonly property real targetHeight: {
                    if (modelData.hasFullscreen)
                        return bgRect.height;
                    if (isUrgent)
                        return bgRect.height * 0.7;
                    if (windowCount === 0)
                        return 0;

                    return bgRect.height * (windowCount / (windowCount + 1));
                }

                onClicked: modelData.activate()

                background: Rectangle {
                    id: bgRect
                    radius: Theme.rounding.small

                    color: {
                        if (workspaceButton.isFocused)
                            return Qt.alpha(Theme.colors.primary_container, 0.3);
                        if (workspaceButton.isActive)
                            return Qt.alpha(Theme.colors.tertiary_container, 0.3);
                        if (workspaceButton.hovered)
                            return Qt.alpha(Theme.colors.surface_container_highest, 0.5);
                        return Qt.alpha(Theme.colors.surface_container, 0.3);
                    }

                    border.width: (workspaceButton.isFocused || workspaceButton.isActive) ? 2 : 1
                    border.color: Qt.alpha(workspaceButton.accentColor, 0.5)

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: workspaceButton.modelData.id

                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.small
                        font.weight: (workspaceButton.isFocused || workspaceButton.isActive) ? Font.Bold : Font.Normal

                        color: {
                            if (workspaceButton.isFocused)
                                return Theme.colors.primary;
                            if (workspaceButton.isActive)
                                return Theme.colors.tertiary;
                            if (workspaceButton.windowCount > 0)
                                return Theme.colors.on_surface_variant;
                            return Theme.colors.outline_variant;
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Item {
                        id: fillWrapper
                        anchors.fill: parent
                        layer.enabled: true

                        Rectangle {
                            id: barRect
                            width: parent.width
                            height: workspaceButton.targetHeight
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: Theme.rounding.small
                            clip: true
                            scale: workspaceButton.hovered ? 1.05 : 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.OutBack
                                }
                            }

                            Behavior on height {
                                NumberAnimation {
                                    duration: 250
                                    easing.type: Easing.OutBack
                                    easing.overshoot: 0.8
                                }
                            }

                            gradient: Gradient {
                                orientation: Gradient.Vertical
                                GradientStop {
                                    position: 0.0
                                    color: Qt.alpha(workspaceButton.accentColor, workspaceButton.hovered ? 1.0 : 0.9)
                                }
                                GradientStop {
                                    position: 1.0
                                    color: Qt.alpha(workspaceButton.accentColor, 0.7)
                                }
                            }

                            Item {
                                id: shimmerItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width * 2
                                x: -width
                                visible: workspaceButton.isUrgent

                                Rectangle {
                                    anchors.fill: parent
                                    rotation: 20
                                    scale: 2.0
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop {
                                            position: 0.0
                                            color: "transparent"
                                        }
                                        GradientStop {
                                            position: 0.5
                                            color: Qt.alpha(Theme.colors.on_error, 0.6)
                                        }
                                        GradientStop {
                                            position: 1.0
                                            color: "transparent"
                                        }
                                    }
                                }

                                NumberAnimation on x {
                                    running: shimmerItem.visible
                                    from: -shimmerItem.width
                                    to: barRect.width
                                    duration: 1200
                                    loops: Animation.Infinite
                                }
                            }
                        }
                    }

                    Item {
                        anchors.fill: parent

                        Text {
                            anchors.centerIn: parent
                            text: workspaceButton.modelData.id

                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.small
                            font.weight: (workspaceButton.isFocused || workspaceButton.isActive) ? Font.Bold : Font.Normal
                            color: Theme.colors.on_primary
                        }

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: fillWrapper
                        }
                    }
                }

                contentItem: Item {}
            }
        }
    }
}
