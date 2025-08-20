pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - (Theme.margin)
    implicitWidth: playerRow.width + Theme.margin * 2
    property string playerIcon: Player.active && Player.active.playbackState == MprisPlaybackState.Playing ? "󰐊" : "󰏤"

    MouseArea {
        id: swapFocus
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onPressed: {
            Player.active.raise();
        }
    }

    MouseArea {
        id: toggleMute
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onPressed: {
            if (Player.active && Player.active.canPause && Player.active.playbackState != MprisPlaybackState.Paused)
                Player.active.pause();
            else if (Player.active && Player.active.canPlay)
                Player.active.play();
        }
    }

    background: Loader {
        active: Player.active
        sourceComponent: Rectangle {
            radius: Theme.rounding.small
            color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    RowLayout {
        id: playerRow
        anchors.centerIn: parent
        Text {
            Layout.minimumWidth: Theme.font.large
            horizontalAlignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large
            }
            color: Theme.colors.secondary
            text: root.playerIcon
        }
        Private.ScrollingText {
            Layout.minimumHeight: Theme.font.large * 1.3
            Layout.maximumWidth: 256
            Layout.minimumWidth: 128
            scrollingText: Player.active && qsTr(`${Player.active.trackArtist} - ${Player.active.trackTitle}`)
            animate: Player.active && Player.active.isPlaying
        }
        Private.Visualizer {
            Layout.fillHeight: true
            Layout.fillWidth: true
            implicitWidth: Theme.playerWidth
            progress: Player.percentageProgress || 0
            isPlaying: Player.active?.isPlaying || false
        }
    }

    action: Action {
        onTriggered: print("No action assigned yet")
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)
        blockShow: !Player.active

        RowLayout {
            spacing: 12
            Image {
                source: Player.active?.trackArtUrl || "" // qmllint disable
                sourceSize: Qt.size(100, 100)
            }
            ColumnLayout {
                id: trackInfo
                Private.ScrollingText {
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.font.normal
                    Layout.maximumWidth: 400
                    Layout.minimumWidth: 128
                    scrollingText: Player.active && qsTr(`${Player.active.trackTitle}`)
                    animate: Player.active && Player.active.isPlaying
                }
                Text {
                    Layout.maximumWidth: 400
                    text: Player.active?.trackArtists || ""
                    color: Theme.colors.on_surface_variant
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
                Text {
                    Layout.maximumWidth: 400
                    text: Player.active?.trackAlbum || ""
                    color: Theme.colors.on_surface_variant
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
                Text {
                    Layout.maximumWidth: 400
                    text: MprisPlaybackState.toString(Player.active?.playbackState)
                    color: Theme.colors.on_surface_variant
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
