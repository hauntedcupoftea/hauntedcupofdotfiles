pragma Singleton

import qs.config
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<int> values: Array(Settings.visualizerBars)
    property int refCount
    property bool isActive: refCount > 0

    function addRef() {
        refCount++;
        if (refCount === 1) {
            cavaProc.running = true;
        }
    }

    function removeRef() {
        refCount = Math.max(0, refCount - 1);
        if (refCount === 0) {
            cavaProc.running = false;
        }
    }

    Connections {
        target: Settings

        function onVisualiserBarsChanged() {
            root.values = Array(Settings.visualizerBars);
            cavaProc.running = false;
            cavaProc.running = true;
        }
    }

    Process {
        id: cavaProc

        running: true
        command: ["sh", "-c", `printf '[general]\nframerate=60\nbars=${Settings.visualizerBars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        stdout: SplitParser {
            onRead: data => {
                if (root.refCount)
                    root.values = data.slice(0, -1).split(";").map(v => parseInt(v, 10));
            }
        }
    }
}
