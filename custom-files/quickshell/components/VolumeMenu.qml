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
    implicitWidth: content.width + Theme.margin * 2
    visible: Audio.ready

    sidebarComponent: "basic-rectangle"

    property bool focusOutput: true
    property real outputAlpha: focusOutput ? 0.8 : 0.45
    property real inputAlpha: focusOutput ? 0.45 : 0.8
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
        radius: Theme.rounding.small
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        border {
            width: 2
            color: (root.focusOutput && Audio.defaultOutput?.audio.muted) || Audio.defaultInput?.audio.muted ? Theme.colors.error : Theme.colors.surface_container
        }

        RowLayout {
            id: content
            anchors.centerIn: parent
            anchors.margins: Theme.margin
            Text {
                Layout.minimumWidth: Theme.font.large
                horizontalAlignment: Qt.AlignHCenter
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.large
                }
                color: root.focusOutput ? Theme.colors.primary : Theme.colors.secondary
                text: root.focusedIcon
            }
            ClippingRectangle {
                id: bg
                Layout.fillHeight: true
                Layout.preferredWidth: Theme.playerWidth
                radius: Theme.rounding.verysmall
                color: Theme.colors.surface_container
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    implicitHeight: bg.height * Audio.defaultOutput?.audio.volume
                    color: Qt.alpha(Theme.colors.primary, root.outputAlpha)

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
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    implicitHeight: bg.height * Audio.defaultInput?.audio.volume
                    color: Qt.alpha(Theme.colors.secondary, root.inputAlpha)
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

    //         font.pixelSize: Theme.font.large
    //     }
    //     Private.StyledText {
    //         Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    //         Layout.rightMargin: Theme.padding
    //         text: "󰍬"

    //         font.pixelSize: Theme.font.large
    //     }
    // }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)

        Text {
            width: 400
            wrapMode: Text.WordWrap
            text: `Current Input: ${Audio.defaultInput?.description} (${Audio.defaultInput?.audio.volume.toFixed(2) * 100}%)\n\nCurrent Output:${Audio.defaultOutput?.description} (${Audio.defaultOutput?.audio.volume.toFixed(2) * 100}%)`
            color: Theme.colors.on_surface
        }
    }
}
