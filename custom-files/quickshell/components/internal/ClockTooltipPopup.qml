import Quickshell
import QtQuick
import "../../theme"
import "../../services"

PopupWindow {
    id: tooltipPopup
    property var targetWidget
    property bool shouldShow: false
    property int showDelay: 800
    property int hideDelay: 200

    anchor {
        item: targetWidget
        rect: Qt.rect(0, targetWidget.height + Theme.margin, 0, 0)
        gravity: Edges.Top | Edges.Left
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
        onTriggered: {
            internal.actuallyVisible = true;
        }
    }

    Timer {
        id: hideTimer
        interval: tooltipPopup.hideDelay
        onTriggered: {
            internal.actuallyVisible = false;
        }
    }

    // Watch for shouldShow changes
    onShouldShowChanged: {
        if (shouldShow) {
            hideTimer.stop();
            showTimer.start();
        } else {
            showTimer.stop();
            hideTimer.start();
        }
    }

    Rectangle {
        id: content
        color: Theme.colors.surface1
        radius: Theme.rounding.verysmall

        implicitWidth: tooltipContent.implicitWidth + (Theme.padding * 2)
        implicitHeight: tooltipContent.implicitHeight + (Theme.padding * 2)

        // Entrance animation
        scale: internal.actuallyVisible ? 1.0 : 0.8
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
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                tooltipPopup.shouldShow = true;
            }
            onExited: {
                tooltipPopup.shouldShow = false;
            }

            Column {
                id: tooltipContent
                anchors.centerIn: parent
                spacing: Theme.margin / 2

                Text {
                    text: "📅 Today: " + Time.time
                    color: Theme.colors.text
                    font {
                        family: Theme.font.family
                        pointSize: Theme.font.sizeBase
                    }
                }

                Text {
                    text: "🌤️ Weather: 22°C Sunny"
                    color: Theme.colors.subtext1
                    font {
                        family: Theme.font.family
                        pointSize: Theme.font.sizeSmall
                    }
                }

                Text {
                    text: "Click for calendar"
                    color: Theme.colors.subtext0
                    font {
                        family: Theme.font.family
                        pointSize: Theme.font.sizeSmall
                    }
                }
            }
        }
    }
}
