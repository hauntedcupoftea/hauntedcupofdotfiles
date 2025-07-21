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
    implicitWidth: Theme.playerWidth

    background: Loader {
        active: Player.active
        sourceComponent: Rectangle {
            radius: Theme.rounding.small
            color: Theme.colors.crust

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: (Theme.margin / 1)
                radius: Theme.rounding.verysmall
                color: Theme.colors.mantle
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    implicitWidth: root.width * Player.percentageProgress
                    color: Theme.colors.surface1
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

        RowLayout {
            spacing: 12
            Image {
                source: Player.active.trackArtUrl
                sourceSize: Qt.size(100, 100)
            }
            ColumnLayout {
                id: tooltipMetaData
                Private.StyledText {
                    Layout.maximumWidth: 400
                    text: `${Player.active.trackTitle}`
                    color: Theme.colors.text
                }
                Text {
                    Layout.maximumWidth: 400
                    text: Player.active.trackArtists
                    color: Theme.colors.subtext0
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
                Text {
                    Layout.maximumWidth: 400
                    text: `${Player.active.trackAlbum} — ${Player.active.trackAlbumArtist}`
                    color: Theme.colors.subtext1
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
                Text {
                    Layout.maximumWidth: 400
                    text: MprisPlaybackState.toString(Player.active.playbackState)
                    color: Theme.colors.subtext1
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.small
                    wrapMode: Text.WordWrap
                }
            }
        }

        // Text {
        //     text: JSON.stringify(Player.active, null, 2)
        //     color: Theme.colors.text
        // }
    }

    Private.ScrollingText {
        anchors.centerIn: root
        scrollingText: Player.active && qsTr(`${Player.active.trackArtist} - ${Player.active.trackTitle}`)
        animate: Player.active && Player.active.isPlaying
        // DEBUG
        // onScrollingTextChanged: print(JSON.stringify(Player.active.metadata, null, 2))
    }
}
