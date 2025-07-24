pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell.Widgets
// import Quickshell.Services.Pipewire
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import qs.config
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - (Theme.margin)
    implicitWidth: Theme.playerWidth

    property bool focusOutput: false
    property real outputAlpha: focusOutput ? 0.9 : 0.45
    property real inputAlpha: focusOutput ? 0.45 : 0.9
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

    action: Action {
        onTriggered: print("No action assigned yet")
    }

    background: Loader {
        active: Audio.ready
        sourceComponent: Rectangle {
            radius: Theme.rounding.small
            color: root.hovered ? Theme.colors.surface1 : Theme.colors.crust

            border {
                width: 2
                color: (root.focusOutput && Audio.defaultOutput.audio.muted) || Audio.defaultInput.audio.muted ? Theme.colors.red : Theme.colors.mantle
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.margin
                Text {
                    Layout.minimumWidth: Theme.font.large
                    horizontalAlignment: Qt.AlignHCenter
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.large
                    }
                    color: root.focusOutput ? Theme.colors.blue : Theme.colors.rosewater
                    text: root.focusedIcon
                }
                ClippingRectangle {
                    id: content
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    radius: Theme.rounding.verysmall
                    color: Theme.colors.surface0
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        implicitWidth: root.width * Audio.defaultOutput.audio.volume
                        color: Qt.alpha(Theme.colors.blue, root.outputAlpha)

                        Behavior on opacity {
                            NumberAnimation {
                                duration: Theme.anims.duration.large
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.anims.curve.standard
                            }
                        }
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        implicitWidth: root.width * Audio.defaultInput.audio.volume
                        color: Qt.alpha(Theme.colors.rosewater, root.inputAlpha)
                    }
                }
            }
        }
    }

    // TODO: convey more information here.
    // THINK: don't think we need this, could use colors and borders instead.
    // RowLayout {
    //     anchors.fill: root
    //     anchors.margins: (Theme.margin * 1)
    //     Private.StyledText {
    //         Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    //         Layout.leftMargin: Theme.padding
    //         text: "󰕾"
    //         color: Theme.colors.text
    //         font.pixelSize: Theme.font.large
    //     }
    //     Private.StyledText {
    //         Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    //         Layout.rightMargin: Theme.padding
    //         text: "󰍬"
    //         color: Theme.colors.text
    //         font.pixelSize: Theme.font.large
    //     }
    // }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)
        blockShow: true

        Text {
            text: JSON.stringify(Audio.defaultInput, null, 2)
            color: Theme.colors.text
        }
    }
}
