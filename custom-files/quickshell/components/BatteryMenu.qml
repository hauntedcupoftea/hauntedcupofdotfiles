import QtQuick
import "../widgets"
import "../services"
import "../theme"
import "internal" as Private
import Quickshell
import Quickshell.Widgets

AbstractBarButton {
    id: batteryIndicator
    implicitWidth: indicator.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin * 2)

    background: ClippingRectangle {
        id: background
        radius: Theme.rounding.verysmall
        color: Theme.colors.crust

        // Fill rectangle that shows battery percentage
        Rectangle {
            id: fillRect
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: parent.height * Battery.percentage
            containmentMask: background
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
            id: indicator
            anchors.centerIn: parent
            text: `${Battery.isCharging ? "󱐋" : " "}${Math.round(Battery.percentage * 100)} ${Battery.profileIcon}`
            weight: 400
            color: {
                if (Battery.isLowAndNotCharging) {
                    return Theme.colors.red;
                }
                if (Battery.percentage > 0.5)
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
