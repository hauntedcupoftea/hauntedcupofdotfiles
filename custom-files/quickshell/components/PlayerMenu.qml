pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell.Services.Mpris
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: playerRow.width + Theme.margin * 2
    property string playerIcon: Player.active && Player.active.playbackState == MprisPlaybackState.Playing ? "󰐊" : "󰏤"
    visible: Player.active

    sidebarComponent: "basic-rectangle"

    MouseArea {
        id: swapFocus
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onPressed: {
            Player.active.raise();
        }

        onWheel: event => {
            var delta = event.angleDelta.y / 120;
            Player.selectPlayer(delta);
            console.log(`Changed player to ${Player.active.desktopEntry ?? Player.active.dbusName}`);
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

    background: Rectangle {
        radius: Theme.rounding.pillMedium
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }

        border.width: 2
        border.color: Qt.alpha(Theme.colors.tertiary, 0.3)
    }

    RowLayout {
        id: playerRow
        anchors.centerIn: parent
        spacing: Theme.margin

        // Play/pause icon
        Text {
            Layout.minimumWidth: Theme.font.large
            horizontalAlignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large
            }
            color: Player.active?.playbackState == MprisPlaybackState.Playing ? Theme.colors.tertiary : Theme.colors.on_surface_variant
            text: root.playerIcon

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.normal
                    easing.type: Easing.OutQuad
                }
            }

            // Bounce when toggling
            scale: toggleMute.pressed ? 0.9 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: Theme.anims.duration.small
                    easing.type: Easing.OutBack
                }
            }
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
            spacing: Theme.padding

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 100
                radius: Theme.rounding.pillMedium
                color: Theme.colors.surface_variant
                clip: true

                // border.width: 2
                // border.color: Qt.alpha(Theme.colors.tertiary, 0.5)

                Image {
                    anchors.fill: parent
                    anchors.margins: parent.border.width
                    source: qsTr(Player.active?.trackArtUrl)
                    fillMode: Image.PreserveAspectCrop

                    Rectangle {
                        anchors.fill: parent
                        visible: parent.status !== Image.Ready
                        color: Theme.colors.surface_container_high
                        radius: Theme.rounding.pillSmall

                        Text {
                            anchors.centerIn: parent
                            text: "󰝚"
                            font.pixelSize: Theme.font.huge
                            color: Theme.colors.on_surface_variant
                            opacity: 0.5
                        }
                    }
                }
            }

            ColumnLayout {
                id: trackInfo
                Layout.preferredWidth: 300
                spacing: Theme.margin

                Private.ScrollingText {
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.font.large
                    Layout.maximumWidth: 300
                    Layout.minimumWidth: 200
                    scrollingText: Player.active ? qsTr(`${Player.active.trackTitle}`) : ""
                    animate: Player.active && Player.active.isPlaying
                }

                Rectangle {
                    Layout.preferredHeight: artistText.height + Theme.margin
                    Layout.preferredWidth: artistText.width + (Theme.padding * 2)
                    radius: Theme.rounding.pillSmall
                    color: Theme.colors.primary_container
                    Text {
                        id: artistText
                        anchors.centerIn: parent
                        text: Player.active?.trackArtists || "Unknown Artist"
                        color: Theme.colors.on_primary_container
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.small
                        font.weight: Font.Medium
                    }
                }

                Rectangle {
                    Layout.preferredHeight: albumText.height + Theme.margin
                    Layout.preferredWidth: albumText.implicitWidth + (Theme.padding * 2)
                    radius: Theme.rounding.small
                    color: Qt.alpha(Theme.colors.secondary_container, 0.6)
                    // visible: Boolean(Player.active?.trackAlbum)

                    Text {
                        id: albumText
                        anchors.centerIn: parent
                        text: Player.active?.trackAlbum || "Unknown Album"
                        color: Theme.colors.on_secondary_container
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.small
                    }
                }

                Rectangle {
                    Layout.preferredHeight: statusText.height + Theme.margin
                    Layout.preferredWidth: statusText.implicitWidth + Theme.padding
                    radius: Theme.rounding.small
                    color: Qt.alpha(Theme.colors.tertiary_container, 0.6)
                    border.width: 1
                    border.color: Qt.alpha(Theme.colors.tertiary, 0.3)

                    Text {
                        id: statusText
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        text: `${MprisPlaybackState.toString(Player.active?.playbackState)} • ${qsTr(Player.playerName || Player.active.dbusName)}`
                        color: Theme.colors.on_tertiary_container
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.smallest
                    }
                }
            }
        }
    }
}
