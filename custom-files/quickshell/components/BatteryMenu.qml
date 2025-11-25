import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.widgets
import qs.services
import qs.theme
import "internal" as Private

AbstractBarButton {
    id: batteryIndicator
    implicitWidth: content.width + (Theme.margin * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    background: Rectangle {
        radius: Theme.rounding.pillMedium

        color: batteryIndicator.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
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

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }

        SequentialAnimation on border.width {
            running: (Battery.isCharging && !Battery.isFullyCharged)
            loops: Animation.Infinite
            NumberAnimation {
                to: 3
                duration: 800
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                to: 1
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }

        RowLayout {
            id: content
            implicitWidth: Theme.playerWidth
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
                color: Theme.colors.secondary
                text: Battery.profileIcon

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anims.duration.normal
                        easing.type: Easing.OutQuad
                    }
                }

                scale: batteryIndicator.pressed ? 0.9 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: Theme.anims.duration.small
                        easing.type: Easing.OutBack
                    }
                }
            }

            ClippingRectangle {
                id: bg
                Layout.fillHeight: true
                Layout.preferredWidth: Theme.playerWidth
                radius: Theme.rounding.pillSmall
                color: Qt.alpha(Theme.colors.secondary_container, 0.8)

                Rectangle {
                    id: batteryFill
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    implicitWidth: bg.width * Number(Battery.percentage)
                    radius: Theme.rounding.pillSmall

                    color: {
                        if (Battery.isCritical)
                            return Theme.colors.error;
                        if (Battery.isLow)
                            return Theme.colors.error;
                        if (Battery.isCharging)
                            return Theme.colors.primary_container;
                        return Theme.colors.secondary;
                    }

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: Theme.anims.duration.normal
                            easing.type: Easing.OutBack
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.anims.duration.large
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Theme.anims.curve.standard
                        }
                    }
                }

                Private.StyledText {
                    text: Number(Battery.percentage * 100)
                    anchors.centerIn: parent
                    color: Theme.colors.surface

                    font.weight: 600
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
            }
        }
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        triggerTarget: batteryIndicator
        targetWidget: batteryIndicator
        position: Qt.rect(batteryIndicator.width / 2, batteryIndicator.height + Theme.padding, 0, 0)

        Private.StyledText {
            text: `${Battery.formatETA(Battery.estimatedTime)}`
            color: Theme.colors.on_surface_variant
        }
    }

    sidebarComponent: "battery-menu"
}
