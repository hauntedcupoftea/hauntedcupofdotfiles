import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.theme
import qs.services
import "internal" as Private

Button {
    id: bluetoothPill

    implicitWidth: content.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - Theme.margin

    readonly property int deviceCount: Bluetooth.deviceCount
    readonly property bool isEnabled: Bluetooth.isEnabled
    readonly property bool hasDevices: deviceCount > 0

    background: Rectangle {
        color: bluetoothPill.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.pillMedium
        border {
            width: 2
            color: {
                if (!bluetoothPill.isEnabled)
                    return Qt.alpha(Theme.colors.outline, 0.3);
                if (bluetoothPill.hasDevices)
                    return Qt.alpha(Theme.colors.tertiary, 0.3);
                return Qt.alpha(Theme.colors.secondary, 0.3);
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.anims.duration.normal
            }
        }
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: Theme.margin

        Text {
            Layout.minimumWidth: Theme.font.large
            horizontalAlignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large
            }
            color: {
                if (!bluetoothPill.isEnabled)
                    return Theme.colors.on_surface_variant;
                if (bluetoothPill.hasDevices)
                    return Theme.colors.tertiary;
                return Theme.colors.secondary;
            }
            text: Bluetooth.status

            // Pulse when actively connected
            opacity: bluetoothPill.hasDevices ? pulseOpacity : 1.0

            property real pulseOpacity: 1.0

            SequentialAnimation on pulseOpacity {
                running: bluetoothPill.hasDevices
                loops: Animation.Infinite
                NumberAnimation {
                    from: 1.0
                    to: 0.6
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    from: 0.6
                    to: 1.0
                    duration: 1500
                    easing.type: Easing.InOutSine
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.normal
                }
            }
        }

        Rectangle {
            visible: bluetoothPill.hasDevices
            Layout.preferredWidth: deviceCountText.implicitWidth + (Theme.margin * 1.5)
            Layout.preferredHeight: deviceCountText.implicitHeight + (Theme.margin)
            radius: Theme.rounding.full

            color: Theme.colors.tertiary_container

            Text {
                id: deviceCountText
                anchors.centerIn: parent
                text: bluetoothPill.deviceCount
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: Font.Medium
                }
                color: Theme.colors.on_tertiary_container
            }
        }
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: bluetoothPill
        triggerTarget: true
        position: Qt.rect(bluetoothPill.width / 2, bluetoothPill.height + Theme.padding, 0, 0)

        ColumnLayout {
            spacing: Theme.margin / 2

            Private.StyledText {
                text: {
                    if (!bluetoothPill.isEnabled)
                        return "Bluetooth Disabled";
                    if (bluetoothPill.hasDevices)
                        return `${bluetoothPill.deviceCount} Device${bluetoothPill.deviceCount > 1 ? "s" : ""} Connected`;
                    return "Bluetooth Enabled";
                }
                color: Theme.colors.on_surface
                font.weight: Font.Medium
            }

            Repeater {
                model: bluetoothPill.hasDevices ? Bluetooth.connectedDevices : []

                delegate: RowLayout {
                    id: layout
                    required property var modelData
                    spacing: Theme.margin

                    Text {
                        text: "󰂱"
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.normal
                        color: Theme.colors.tertiary
                    }

                    Private.StyledText {
                        text: layout.modelData.name || layout.modelData.address || "Unknown Device"
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.small
                    }
                }
            }

            Private.StyledText {
                visible: bluetoothPill.isEnabled && !bluetoothPill.hasDevices
                text: "No devices connected"
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.small
                opacity: 0.7
            }

            Private.StyledText {
                text: "Click to manage devices"
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.smaller
                opacity: 0.5
            }
        }
    }
}
