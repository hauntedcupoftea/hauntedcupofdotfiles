import QtQuick
import Quickshell.Widgets

import "../theme"
import "../services"
import "../widgets"
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - (Theme.margin)
    implicitWidth: 100

    background: Rectangle {

        anchors.fill: root
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
                width: Player.active.isPlaying ? root.width * Player.percentageProgress : 0
                color: Theme.colors.overlay0
            }
        }
    }

    Private.ScrollingText {
        anchors.centerIn: parent
        scrollingText: Player.active.isPlaying ? qsTr(`${Player.active.trackArtist} - ${Player.active.trackTitle}`) : "Not Playing"
        onScrollingTextChanged: print(JSON.stringify(Player.active.metadata, null, 2))
    }
}
