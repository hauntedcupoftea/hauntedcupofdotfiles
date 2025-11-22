pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell.Widgets
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import qs.config
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: content.width + Theme.margin * 2
    visible: Audio.ready

    sidebarComponent: "basic-rectangle"

    property bool focusOutput: true
    property real outputAlpha: focusOutput ? 1.0 : 0.5
    property real inputAlpha: focusOutput ? 0.5 : 1.0
    property string focusedIcon: focusOutput ? Audio.defaultOutput?.audio.muted ? "󰝟" : "󰕾" : Audio.defaultInput?.audio.muted ? "󰍭" : "󰍬"

    MouseArea {
        id: swapFocus
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onPressed: {
            root.focusOutput = !root.focusOutput;
        }

        onWheel: event => {
            var delta = event.angleDelta.y / 12000;
            if (root.focusOutput)
                Audio.changeOutputVolume(delta * Settings.volumeChange);
            else
                Audio.changeInputVolume(delta * Settings.volumeChange);
        }
    }

    MouseArea {
        id: toggleMute
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onPressed: {
            if (root.focusOutput)
                Audio.toggleOutputMute();
            else
                Audio.toggleInputMute();
        }
    }

    background: Rectangle {
        radius: Theme.rounding.pillMedium

        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }

        border {
            width: 2
            color: {
                if ((root.focusOutput && Audio.defaultOutput?.audio.muted) || (!root.focusOutput && Audio.defaultInput?.audio.muted))
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
            running: (root.focusOutput && Audio.defaultOutput?.audio.muted) || (!root.focusOutput && Audio.defaultInput?.audio.muted)
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
                color: root.focusOutput ? Theme.colors.primary : Theme.colors.secondary
                text: root.focusedIcon

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anims.duration.normal
                        easing.type: Easing.OutQuad
                    }
                }

                scale: toggleMute.pressed || swapFocus.pressed ? 0.9 : 1.0
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
                color: 'transparent'

                border.width: 1
                border.color: Qt.alpha(Theme.colors.outline, 0.2)

                Rectangle {
                    id: outputFill
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    implicitHeight: bg.height * (Audio.defaultOutput?.audio.volume || 0)

                    color: Qt.alpha(Theme.colors.primary, root.outputAlpha)

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

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 2
                        visible: outputFill.implicitHeight > 3

                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop {
                                position: 0.0
                                color: "transparent"
                            }
                            GradientStop {
                                position: 0.5
                                color: Qt.alpha(Theme.colors.on_primary, 0.5)
                            }
                            GradientStop {
                                position: 1.0
                                color: "transparent"
                            }
                        }

                        SequentialAnimation on opacity {
                            running: root.focusOutput
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 0.3
                                duration: 1200
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                to: 1.0
                                duration: 1200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                Rectangle {
                    id: inputFill
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    implicitHeight: bg.height * (Audio.defaultInput?.audio.volume || 0)

                    color: Qt.alpha(Theme.colors.secondary, root.inputAlpha)

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

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 2
                        visible: inputFill.implicitHeight > 3

                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop {
                                position: 0.0
                                color: "transparent"
                            }
                            GradientStop {
                                position: 0.5
                                color: Qt.alpha(Theme.colors.on_secondary, 0.5)
                            }
                            GradientStop {
                                position: 1.0
                                color: "transparent"
                            }
                        }

                        SequentialAnimation on opacity {
                            running: !root.focusOutput
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 0.3
                                duration: 1200
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                to: 1.0
                                duration: 1200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)

        ColumnLayout {
            spacing: Theme.margin / 2

            Text {
                Layout.maximumWidth: Theme.maximumTooltipWidth
                wrapMode: Text.WordWrap
                text: `Output: ${Audio.defaultOutput?.description || "None"}`
                color: Theme.colors.on_surface
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: root.focusOutput ? Font.Bold : Font.Normal
                }
            }

            Text {
                text: `${(Audio.defaultOutput?.audio.volume.toFixed(2) * 100).toFixed(0)}%`
                color: Theme.colors.primary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: Font.Medium
                }
            }

            Rectangle {
                Layout.maximumWidth: Theme.maximumTooltipWidth
                implicitHeight: 1
                color: Theme.colors.outline_variant
            }

            Text {
                Layout.maximumWidth: Theme.maximumTooltipWidth
                wrapMode: Text.WordWrap
                text: `Input: ${Audio.defaultInput?.description || "None"}`
                color: Theme.colors.on_surface
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: !root.focusOutput ? Font.Bold : Font.Normal
                }
            }

            Text {
                text: `${(Audio.defaultInput?.audio.volume.toFixed(2) * 100).toFixed(0)}%`
                color: Theme.colors.secondary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: Font.Medium
                }
            }
        }
    }
}
