import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../widgets"
import "../services"
import "../theme"
import "internal" as Private

AbstractBarButton {
    id: batteryIndicator
    implicitWidth: batLayout.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    background: Rectangle {
        color: batteryIndicator.hovered ? Theme.colors.surface0 : Theme.colors.crust
        radius: Theme.rounding.small
    }

    RowLayout {
        id: batLayout
        anchors.centerIn: batteryIndicator

        Private.StyledText {
            id: indicator
            text: `${Battery.isCharging ? "󱐋" : ""}${Math.round(Battery.percentage * 100)}%`
            weight: 400
            color: Battery.isLowAndNotCharging ? Theme.colors.red : Theme.colors.text

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }
        ClippingRectangle {
            id: batteryCan
            radius: Theme.rounding.verysmall
            color: Theme.colors.surface0
            implicitWidth: Theme.padding * 2
            implicitHeight: batteryIndicator.height - (Theme.padding)

            // Fill rectangle that shows battery percentage
            Rectangle {
                id: fillRect
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: parent.height * Battery.percentage
                containmentMask: batteryCan
                color: {
                    if (Battery.isCritical)
                        return "red";
                    if (Battery.isLow)
                        return Theme.colors.red;
                    if (Battery.isCharging)
                        return Theme.colors.green;
                    return Theme.colors.blue;
                }

                // Smooth animation when percentage changes
                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
            Private.StyledText {
                anchors.centerIn: parent
                text: Battery.profileIcon
                weight: 400
                color: {
                    if (Battery.isLowAndNotCharging) {
                        return Theme.colors.red;
                    }
                    if (Battery.percentage > 0.44)
                        return Theme.colors.base;
                    return Theme.colors.text;
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
            color: Theme.colors.subtext0
        }
    }
}
