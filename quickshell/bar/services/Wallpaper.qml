pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

// IPC (qs ipc call wallpaper <method>):
//   next()       — pick next random wallpaper
//   set(path)    — set specific file
//   toggle()     — pause/resume auto-rotation
//   reload()     — rescan directory

Singleton {
    id: root

    property string current: ""
    property bool autoRotate: true
    property bool ready: false
    property bool swwwReady: false

    readonly property string defaultPath: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    property string configuredPath: Settings.wallpaperPath
    property int intervalMinutes: Settings.wallpaperIntervalMinutes
    property bool runMatugen: Settings.wallpaperRunMatugen
    property string transition: Settings.wallpaperTransition
    property real transitionDuration: Settings.wallpaperTransitionDuration
    property int transitionFps: Settings.wallpaperTransitionFps
    property int transitionAngle: Settings.wallpaperTransitionAngle

    property var wallpaperList: []
    property bool pathIsFile: false
    property int lastIndex: -1

    Component.onCompleted: {
        killAwww.running = true;
    }

    onConfiguredPathChanged: root.initPath()

    Connections {
        target: Settings
        function onWallpaperPathChanged() {
            root.configuredPath = Settings.wallpaperPath;
        }
        function onWallpaperIntervalMinutesChanged() {
            root.intervalMinutes = Settings.wallpaperIntervalMinutes;
        }
        function onWallpaperTransitionChanged() {
            root.transition = Settings.wallpaperTransition;
        }
        function onWallpaperTransitionFpsChanged() {
            root.transitionFps = Settings.wallpaperTransitionFps;
        }
        function onWallpaperTransitionAngleChanged() {
            root.transitionAngle = Settings.wallpaperTransitionAngle;
        }
    }

    Process {
        id: killAwww
        command: ["pkill", "awww-daemon"]
        running: false
        onExited: (code, status) => {
            startAwww.running = true;
        }
    }

    Process {
        id: startAwww
        command: ["awww-daemon"]
        running: false
        onExited: (code, status) => {
            if (code !== 0) {
                console.warn("[Wallpaper] awww-daemon exited with code " + code);
            }
        }
    }

    Timer {
        id: awwwReadyTimer
        interval: 300
        running: true
        repeat: false
        onTriggered: {
            root.swwwReady = true;
            root.initPath();
        }
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
                    root.ready = true;
                    root.setWallpaper(root.configuredPath);
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
                    console.warn("[Wallpaper] No images in " + root.configuredPath);
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
        if (!path || path === "" || !root.swwwReady)
            return;
        root.current = path;

        awwwCmd.command = ["awww", "img", path, "--transition-type", root.transition, "--transition-fps", root.transitionFps.toString(), "--transition-step", root.transitionAngle.toString()];
        awwwCmd.running = true;
    }

    Process {
        id: awwwCmd
        running: false
        onExited: (code, status) => {
            if (code !== 0) {
                console.warn("[Wallpaper] awww img failed with code " + code);
                return;
            }
            // awww succeeded → run matugen (ThemeColors.qml watches theme.json)
            if (root.runMatugen) {
                const types = ["scheme-fidelity", "scheme-vibrant", "scheme-expressive"];
                const type = types[Math.floor(Math.random() * types.length)];
                const index = String(Math.floor(Math.random() * 4));
                matugenCmd.command = ["matugen", "image", root.current, "--source-color-index", index, "-t", type];
                matugenCmd.running = true;
                wallustCmd.command = ["wallust", "run", root.current, "-b", "wal", "-p", "saliencedark16", "--check-contrast", "--quiet", "--skip-sequences"];
                wallustCmd.running = true;
            }
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

    Process {
        id: wallustCmd
        running: false
        onExited: (code, status) => {
            if (code !== 0)
                console.warn("[Wallpaper] wallust exited with code " + code);
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
            console.log("[Wallpaper] auto-rotate: " + root.autoRotate);
        }
        function reload(): void {
            root.wallpaperList = [];
            root.lastIndex = -1;
            root.initPath();
        }
    }
}
