pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> playerList: Mpris.players.values
    readonly property MprisPlayer active: selectedPlayer ?? null
    property int activeIndex: 0
    property string playerName: selectedPlayer?.identity ?? null
    property MprisPlayer selectedPlayer: playerList[activeIndex] ?? null

    onPlayerListChanged: {
        if (playerName) {
            const index = playerList.findIndex(item => item.desktopEntry === playerName);
            activeIndex = index !== -1 ? index : 0;
        } else {
            activeIndex = 0;
        }
    }

    onActiveChanged: {
        if (root.active) {
            root.active.positionChanged();
        }
    }

    readonly property real percentageProgress: {
        if (!active || !active?.lengthSupported)
            return 0;
        return active.position / (active.length);
    }

    function selectPlayer(delta: int) {
        activeIndex = (activeIndex + delta + playerList.length) % playerList.length;
    }

    FrameAnimation {
        running: root.active && root.active.playbackState == MprisPlaybackState.Playing
        onTriggered: if (root.active) {
            root.active.positionChanged();
        }
    }
}
