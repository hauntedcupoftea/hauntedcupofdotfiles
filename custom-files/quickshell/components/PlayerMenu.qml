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
    implicitWidth: Theme.playerWidth + Theme.font.large
    property string playerIcon: Player.active && Player.active.playbackState == MprisPlaybackState.Playing ? "󰐊" : "󰏤"

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
                    color: Theme.colors.secondary
                    text: root.playerIcon
                }
                ClippingRectangle {
                    id: bg
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    implicitWidth: Theme.playerWidth
                    radius: Theme.rounding.verysmall
                    color: Theme.colors.surface_container
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        implicitWidth: bg.width * Player.percentageProgress
                        color: Qt.alpha(Theme.colors.primary, 0.75)
                    }
                    Private.ScrollingText {
                        anchors.centerIn: parent
                        scrollingText: Player.active && qsTr(`${Player.active.trackArtist} - ${Player.active.trackTitle}`)
                        animate: Player.active && Player.active.isPlaying
                        // DEBUG
                        // onScrollingTextChanged: print(JSON.stringify(Player.active.metadata, null, 2))
                    }
                }
            }
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
                Private.StyledText {
                    Layout.maximumWidth: 400
                    text: `${Player.active?.trackTitle}`
                    color: Theme.colors.on_surface
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
                    text: `${Player.active?.trackAlbum}`
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
