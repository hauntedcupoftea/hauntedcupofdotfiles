pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Wallpaper service singleton.
//
// Reads config from ~/.config/hauntedcupof/wallpaper.json at startup and
// on file change. WallpaperLayer.qml reacts to `current` changing.
//
// Config file format (all fields optional, defaults shown):
// {
//   "path": "~/Pictures/Wallpapers",   // file → stays fixed; directory → rotates
//   "intervalMinutes": 30,             // ignored when path is a file
//   "runMatugen": true                 // set false to skip theme generation
// }
//
// IPC (qs ipc call wallpaper <method>):
//   next()         — pick next random wallpaper immediately
//   set(path)      — set a specific file by absolute path
//   toggle()       — pause/resume auto-rotation
//   reload()       — rescan directory and pick a new wallpaper

Singleton {
    id: root

    property string current: ""
    property bool autoRotate: true
    property bool ready: false

    readonly property string defaultPath: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    property string configuredPath: defaultPath
    property int intervalMinutes: 30
    property bool runMatugen: true

    property var wallpaperList: []
    property bool pathIsFile: false
    property int lastIndex: -1

    onDefaultPathChanged: console.info(defaultPath)

    readonly property FileView configFile: FileView {
        id: configView
        path: Qt.resolvedUrl("../wallpaper.json")
        watchChanges: true
        onFileChanged: configView.reload()
        onLoaded: {
            try {
                const cfg = JSON.parse(text());
                if (cfg.path !== undefined)
                    root.configuredPath = cfg.path.replace(/^~/, Quickshell.env("HOME"));
                if (cfg.intervalMinutes !== undefined)
                    root.intervalMinutes = cfg.intervalMinutes;
                if (cfg.runMatugen !== undefined)
                    root.runMatugen = cfg.runMatugen;
                console.log("[Wallpaper] Config: path=" + root.configuredPath + " interval=" + root.intervalMinutes + "m" + " matugen=" + root.runMatugen);
            } catch (e) {
                // File missing or malformed — defaults already set, proceed
            }
            root.initPath();
        }
        Component.onCompleted: configView.reload()
    }

    function initPath() {
        pathChecker.command = ["bash", "-c", `[ -f "${root.configuredPath}" ] && echo file ` + `|| ([ -d "${root.configuredPath}" ] && echo dir || echo missing)`];
        pathChecker.running = true;
    }

    Process {
        id: pathChecker
        running: false
        stdout: SplitParser {
            onRead: data => {
                const result = data.trim();
                if (result === "file") {
                    root.pathIsFile = true;
                    root.wallpaperList = [root.configuredPath];
                    root.current = root.configuredPath;
                    root.ready = true;
                    if (root.runMatugen) {
                        matugenCmd.command = ["matugen", "image", root.current];
                        matugenCmd.running = true;
                    }
                } else if (result === "dir") {
                    root.pathIsFile = false;
                    scanProcess.running = true;
                } else {
                    console.warn("[Wallpaper] Path not found: " + root.configuredPath);
                    root.configuredPath = root.defaultPath;
                    scanProcess.running = true;
                }
            }
        }
    }

    Process {
        id: scanProcess
        running: false
        command: ["bash", "-c", `find "${root.configuredPath}" -maxdepth 2 -type f ` + `\\( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" ` + `-o -iname "*.webp" -o -iname "*.gif" \\) | sort`]
        stdout: StdioCollector {
            onStreamFinished: {
                const files = text.trim().split("\n").filter(f => f.length > 0);
                if (files.length === 0) {
                    console.warn("[Wallpaper] No images found in " + root.configuredPath);
                    return;
                }
                root.wallpaperList = files;
                root.ready = true;
                console.log("[Wallpaper] Found " + files.length + " wallpapers");
                root.pickRandom();
            }
        }
    }

    function pickRandom() {
        if (wallpaperList.length === 0)
            return;
        if (wallpaperList.length === 1) {
            setWallpaper(wallpaperList[0]);
            return;
        }
        let idx = lastIndex;
        while (idx === lastIndex)
            idx = Math.floor(Math.random() * wallpaperList.length);
        lastIndex = idx;
        setWallpaper(wallpaperList[idx]);
    }

    function setWallpaper(path) {
        if (!path || path === "")
            return;
        root.current = path;
        if (root.runMatugen) {
            matugenCmd.command = ["matugen", "image", path];
            matugenCmd.running = true;
        }
    }

    Process {
        id: matugenCmd
        running: false
        onExited: (code, status) => {
            if (code !== 0)
                console.warn("[Wallpaper] matugen exited with code " + code);
        }
    }

    Timer {
        id: rotationTimer
        interval: root.intervalMinutes * 60 * 1000
        running: root.autoRotate && !root.pathIsFile && root.wallpaperList.length > 1
        repeat: true
        onTriggered: root.pickRandom()
    }
    onIntervalMinutesChanged: rotationTimer.restart()

    IpcHandler {
        target: "wallpaper"
        function next(): void {
            root.pickRandom();
        }
        function set(path: string): void {
            if (path)
                root.setWallpaper(path);
        }
        function toggle(): void {
            root.autoRotate = !root.autoRotate;
        }
        function reload(): void {
            root.wallpaperList = [];
            root.lastIndex = -1;
            root.initPath();
        }
    }
}
