pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services
import qs.widgets
import qs.config
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: content.width + (Theme.margin * 2)
    visible: Audio.ready

    sidebarComponent: "basic-rectangle"

    property bool focusOutput: true

    readonly property real barHeight: Theme.barHeight - (Theme.margin * 2.5)
    readonly property real barWidth: Theme.playerWidth

    property string focusedIcon: {
        if (focusOutput) {
            return Audio.defaultOutput?.audio.muted ? "󰝟" : "󰕾";
        } else {
            return Audio.defaultInput?.audio.muted ? "󰍭" : "󰍬";
        }
    }

    MouseArea {
        id: interactionArea
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton | Qt.RightButton

        onPressed: mouse => {
            if (mouse.button === Qt.MiddleButton)
                root.focusOutput = !root.focusOutput;
            if (mouse.button === Qt.RightButton) {
                if (root.focusOutput)
                    Audio.toggleOutputMute();
                else
                    Audio.toggleInputMute();
            }
        }

        onWheel: event => {
            var delta = event.angleDelta.y / 12000;
            if (root.focusOutput)
                Audio.changeOutputVolume(delta * Settings.volumeChange);
            else
                Audio.changeInputVolume(delta * Settings.volumeChange);
        }
    }

    background: Rectangle {
        id: pillBackground
        radius: Theme.rounding.pillMedium
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
            }
        }

        border.width: 2
        border.color: {
            const isMuted = (root.focusOutput && Audio.defaultOutput?.audio.muted) || (!root.focusOutput && Audio.defaultInput?.audio.muted);
            return isMuted ? Theme.colors.error : Qt.alpha(Theme.colors.tertiary, 0.3);
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 150
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
            color: root.focusOutput ? Theme.colors.primary : Theme.colors.secondary
            text: root.focusedIcon

            scale: interactionArea.pressed ? 0.9 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        Item {
            id: volumebars
            Layout.preferredWidth: root.barWidth
            Layout.preferredHeight: root.barHeight

            property color inputColor: Audio.defaultInput?.audio.muted ? Theme.colors.error : Theme.colors.tertiary
            property color outputColor: Audio.defaultOutput?.audio.muted ? Theme.colors.error : Theme.colors.primary

            Private.ProgressBar {
                anchors.fill: parent
                value: Number(Audio.defaultInput?.audio.volume)
                active: true
                radius: Theme.rounding.pillSmall

                backgroundColor: "transparent"
                accentColor: Qt.alpha(volumebars.inputColor, root.focusOutput ? 0.3 : 0.8)
                borderWidth: 1
                borderColor: Qt.alpha(volumebars.inputColor, 0.1)
                shimmerEnabled: Boolean(Audio.defaultInput?.audio.muted)
            }

            Private.ProgressBar {
                anchors.fill: parent
                value: Number(Audio.defaultOutput?.audio.volume)
                active: true
                radius: Theme.rounding.pillSmall
                backgroundColor: "transparent"
                accentColor: Qt.alpha(volumebars.outputColor, root.focusOutput ? 0.8 : 0.3)
                borderWidth: 1
                borderColor: Qt.alpha(volumebars.outputColor, 0.1)
                shimmerEnabled: Boolean(Audio.defaultOutput?.audio.muted)
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

            Private.StyledText {
                Layout.maximumWidth: Theme.maximumTooltipWidth
                text: `Output: ${Audio.defaultOutput?.description || "None"}`
                font.weight: root.focusOutput ? Font.Bold : Font.Normal
            }
            Private.StyledText {
                text: `${(Audio.defaultOutput?.audio.volume.toFixed(2) * 100).toFixed(0)}%`
                color: Theme.colors.primary
                font.pixelSize: Theme.font.small
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Theme.colors.outline_variant
                opacity: 0.3
            }

            Private.StyledText {
                Layout.maximumWidth: Theme.maximumTooltipWidth
                text: `Input: ${Audio.defaultInput?.description || "None"}`
                font.weight: !root.focusOutput ? Font.Bold : Font.Normal
            }
            Private.StyledText {
                text: `${(Audio.defaultInput?.audio.volume.toFixed(2) * 100).toFixed(0)}%`
                color: Theme.colors.secondary
                font.pixelSize: Theme.font.small
            }
        }
    }
}
