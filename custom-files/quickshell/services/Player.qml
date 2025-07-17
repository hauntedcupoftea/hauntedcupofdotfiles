pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> playerList: Mpris.players.values
    readonly property MprisPlayer active: selectedPlayer ?? playerList[0] ?? null
    property MprisPlayer selectedPlayer
    readonly property real percentageProgress: {
        if (!active || !active?.length)
            return 0;
        return active.position / (active.length);
    }

    FrameAnimation {
        running: root.active && root.active.playbackState == MprisPlaybackState.Playing
        onTriggered: root.active.positionChanged()
    }
}
