pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> playerList: Mpris.players.values
    readonly property MprisPlayer active: selectedPlayer ?? null
    property int activeIndex: 0
    property MprisPlayer selectedPlayer: playerList[activeIndex] ?? null

    readonly property real percentageProgress: {
        if (!active || !active?.length)
            return 0;
        return active.position / (active.length);
    }

    function selectPlayer(delta: int) {
        activeIndex = (activeIndex + delta + playerList.length) % playerList.length;
    }

    FrameAnimation {
        running: root.active && root.active.playbackState == MprisPlaybackState.Playing
        onTriggered: root.active.positionChanged()
    }
}
