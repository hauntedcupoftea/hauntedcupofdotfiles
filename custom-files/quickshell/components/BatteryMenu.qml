import QtQuick
import "../widgets"
import "../services"
import "../theme"
import "internal" as Private
import Quickshell
import Quickshell.Widgets

AbstractBarButton {
    id: batteryIndicator
    implicitWidth: indicator.width + (Theme.padding * 4)
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
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * Battery.percentage
            containmentMask: background
            color: {
                if (Battery.isCritical)
                    return "red";
                if (Battery.isLow)
                    return Theme.colors.red;
                if (Battery.isCharging)
                    return Theme.colors.blue;
                return Theme.colors.green;
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

        Text {
            id: indicator
            anchors.centerIn: parent
            text: `${Battery.isCharging ? "󱐋 " : ""}${Math.round(Battery.percentage * 100)}% ${Battery.profileIcon}`
            color: Theme.colors.surface2
            font.pixelSize: Theme.font.small
            font.weight: 700
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
