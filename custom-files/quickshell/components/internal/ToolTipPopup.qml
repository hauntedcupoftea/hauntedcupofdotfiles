import Quickshell
import QtQuick
import "../../theme"

PopupWindow {
    id: tooltipPopup

    // Required properties
    required property var targetWidget
    required property bool triggerTarget
    required property rect position
    required property int expandDirection

    // Optional properties
    property int showDelay: 200
    property int hideDelay: 200
    property color backgroundColor: Theme.colors.surface1
    property real backgroundRadius: Theme.rounding.verysmall
    property bool blockShow: false

    // do not mess with these unless required
    default property alias data: contentContainer.data
    property bool shouldShow: (targetWidget?.hovered ?? false) || isHovered
    property bool isHovered: mouseArea.containsMouse

    function forceHide() {
        showTimer.stop();
        hideTimer.start();
    }

    anchor {
        item: targetWidget
        rect: position
        gravity: expandDirection
    }

    color: "transparent"
    visible: internal.actuallyVisible
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    QtObject {
        id: internal
        property bool actuallyVisible: false
    }

    // Delay timers for smooth hover behavior
    Timer {
        id: showTimer
        interval: tooltipPopup.showDelay
        onTriggered: internal.actuallyVisible = true
    }

    Timer {
        id: hideTimer
        interval: tooltipPopup.hideDelay
        onTriggered: internal.actuallyVisible = false
    }

    // Watch for shouldShow changes
    onShouldShowChanged: {
        if (shouldShow && !blockShow) {
            hideTimer.stop();
            showTimer.start();
        } else {
            showTimer.stop();
            hideTimer.start();
        }
    }

    Rectangle {
        id: content
        color: tooltipPopup.backgroundColor
        radius: tooltipPopup.backgroundRadius
        implicitWidth: contentContainer.implicitWidth + (Theme.padding * 2)
        implicitHeight: contentContainer.implicitHeight + (Theme.padding * 2)

        // Smooth scale + fade animation
        scale: internal.actuallyVisible ? 1.0 : 0.85
        opacity: internal.actuallyVisible ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.anims.curve.standard
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.anims.curve.standard
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            // Forward clicks to target widget action if it exists
            onClicked: {
                if (tooltipPopup.targetWidget?.action && tooltipPopup.triggerTarget) {
                    tooltipPopup.targetWidget.action.trigger();
                }
            }
        }

        // Content container - this is where parent components inject their content
        Item {
            id: contentContainer
            anchors.centerIn: parent
            // Size will be determined by child content
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
