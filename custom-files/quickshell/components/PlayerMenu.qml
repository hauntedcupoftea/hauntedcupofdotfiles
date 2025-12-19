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
            progress: Player.percentageProgress
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

            // Album art
            Rectangle {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                radius: Theme.rounding.small
                color: Theme.colors.surface_variant
                clip: true

                border.width: 1
                border.color: Qt.alpha(Theme.colors.outline_variant, 0.5)

                Image {
                    anchors.fill: parent
                    source: qsTr(Player.active?.trackArtUrl || "")
                    fillMode: Image.PreserveAspectCrop

                    Rectangle {
                        anchors.fill: parent
                        visible: parent.status !== Image.Ready
                        color: Theme.colors.surface_container_high
                        radius: parent.parent.radius

                        Text {
                            anchors.centerIn: parent
                            text: "󰝚"
                            font.pixelSize: Theme.font.huge
                            color: Theme.colors.on_surface_variant
                            opacity: 0.3
                        }
                    }
                }
            }

            ColumnLayout {
                id: trackInfo
                Layout.maximumWidth: 280
                Layout.minimumWidth: 180
                spacing: Theme.margin / 2

                // Title - conditionally scrolling or wrapping
                Loader {
                    id: titleLoader
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.font.larger

                    property string titleText: Player.active?.trackTitle || "Unknown Title"
                    property bool needsScroll: {
                        let temp = Qt.createQmlObject('import QtQuick; Text { font.family: "' + Theme.font.family + '"; font.pixelSize: ' + Theme.font.larger + '; font.weight: Font.DemiBold }', titleLoader);
                        temp.text = titleText;
                        let tooLong = temp.width > 280;
                        temp.destroy();
                        return tooLong;
                    }

                    sourceComponent: needsScroll ? scrollingTitle : wrappingTitle
                }

                Component {
                    id: scrollingTitle
                    Private.ScrollingText {
                        scrollingText: titleLoader.titleText
                        animate: Player.active?.isPlaying || false
                        implicitHeight: Theme.font.larger * 1.2
                    }
                }

                Component {
                    id: wrappingTitle
                    Text {
                        text: titleLoader.titleText
                        color: Theme.colors.on_surface
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.larger
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                }

                // Artist
                Text {
                    Layout.fillWidth: true
                    text: Player.active?.trackArtists || "Unknown Artist"
                    color: Theme.colors.primary
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.normal
                    font.weight: Font.Medium
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                // Album
                Text {
                    Layout.fillWidth: true
                    text: Player.active?.trackAlbum || "Unknown Album"
                    color: Theme.colors.on_surface_variant
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    opacity: 0.8
                }

                // Separator
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.topMargin: Theme.margin / 4
                    Layout.bottomMargin: Theme.margin / 4
                    color: Theme.colors.outline_variant
                    opacity: 0.3
                }

                // Status row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.margin

                    Text {
                        text: {
                            switch (Player.active?.playbackState) {
                            case MprisPlaybackState.Playing:
                                return "󰐊";
                            case MprisPlaybackState.Paused:
                                return "󰏤";
                            case MprisPlaybackState.Stopped:
                                return "󰓛";
                            default:
                                return "󰝚";
                            }
                        }
                        color: Player.active?.playbackState == MprisPlaybackState.Playing ? Theme.colors.tertiary : Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.normal
                    }

                    Text {
                        Layout.fillWidth: true
                        text: qsTr(Player.playerName || "")
                        color: Theme.colors.on_surface_variant
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.smaller
                        elide: Text.ElideRight
                        opacity: 0.7
                    }
                }
            }
        }
    }
}
