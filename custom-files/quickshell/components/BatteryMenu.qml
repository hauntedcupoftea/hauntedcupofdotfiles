pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.widgets
import qs.services
import qs.theme
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: content.width + (Theme.margin * 2)
    implicitHeight: Theme.barHeight - Theme.margin

    sidebarComponent: "battery-menu"

    readonly property bool isCharging: Battery.isCharging
    readonly property bool isCritical: Battery.isCritical || (Battery.isLowAndNotCharging)

    readonly property color stateColor: {
        if (isCritical)
            return Theme.colors.error;
        if (isCharging)
            return Theme.colors.primary;
        if (Battery.percentage < 0.3)
            return Theme.colors.tertiary;
        return Theme.colors.secondary;
    }

    readonly property real barHeight: Theme.barHeight - (Theme.margin * 2.5)
    readonly property real barPadding: Theme.margin / 4

    background: Rectangle {
        id: container
        radius: Theme.rounding.pillMedium
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        border {
            width: 2
            color: {
                if ((Battery.isCritical) || (Battery.isLowAndNotCharging))
                    return Theme.colors.error;
                return Qt.alpha(Theme.colors.primary, 0.3);
            }
        }
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        anchors.margins: Theme.margin
        spacing: Theme.margin

        Text {
            Layout.minimumWidth: Theme.font.large
            horizontalAlignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large
            }
            color: root.stateColor
            text: Battery.profileIcon

            scale: root.pressed ? 0.9 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutBack
                }
            }
        }

        Rectangle {
            id: barTrack
            Layout.preferredWidth: Theme.playerWidth
            Layout.preferredHeight: root.barHeight
            radius: Theme.rounding.pillSmall

            color: Qt.alpha(root.stateColor, 0.12)
            border.width: 1
            border.color: Qt.alpha(root.stateColor, 0.2)

            Private.StyledText {
                anchors.centerIn: parent
                text: Math.round(Battery.percentage * 100)
                font.weight: Font.Bold
                font.pixelSize: Theme.font.small
                color: root.stateColor
            }

            Rectangle {
                id: fill
                x: root.barPadding
                y: root.barPadding
                height: parent.height - (root.barPadding * 2)
                radius: Math.max(0, parent.radius - root.barPadding)
                color: root.stateColor

                width: {
                    let availableWidth = barTrack.width - (root.barPadding * 2);
                    let target = availableWidth * Math.min(Math.max(Battery.percentage, 0.0), 1.0);
                    return Battery.percentage > 0 ? Math.max(target, height) : 0;
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutExpo
                    }
                }

                Item {
                    anchors.fill: parent
                    clip: true

                    Private.StyledText {
                        width: barTrack.width
                        height: barTrack.height
                        x: -fill.x
                        y: -fill.y

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        text: Math.round(Battery.percentage * 100)
                        font.weight: Font.Bold
                        font.pixelSize: Theme.font.small
                        color: Theme.colors.surface
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "white"
                    opacity: 0
                    visible: root.isCharging

                    SequentialAnimation on opacity {
                        running: root.isCharging
                        loops: Animation.Infinite
                        NumberAnimation {
                            to: 0.25
                            duration: 1000
                            easing.type: Easing.InOutSine
                        }
                        NumberAnimation {
                            to: 0
                            duration: 1000
                            easing.type: Easing.InOutSine
                        }
                    }
                }
            }
        }
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        triggerTarget: root
        targetWidget: root
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)

        ColumnLayout {
            spacing: 2
            Private.StyledText {
                text: root.isCharging ? "Plugged In" : (root.isCritical ? "Critical" : "Discharging")
                font.weight: Font.Bold
                color: root.stateColor
            }
            Private.StyledText {
                text: Battery.formatETA(Battery.estimatedTime)
                color: Theme.colors.on_surface_variant
            }
        }
    }
}
