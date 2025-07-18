pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets

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

    Private.ScrollingText {
        anchors.centerIn: root
        scrollingText: Player.active && qsTr(`${Player.active.trackArtist} - ${Player.active.trackTitle}`)
        animate: Player.active && Player.active.isPlaying
        // DEBUG
        // onScrollingTextChanged: print(JSON.stringify(Player.active.metadata, null, 2))
    }
}
