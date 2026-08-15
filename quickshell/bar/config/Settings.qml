pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string configFilePath: Quickshell.env("HOME") + "/.config/hauntedcupofbar.json"

    // Visualizer
    property int visualizerBars: 8
    property int visualizerFPS: 60

    // Battery thresholds
    property int batteryLow: 20
    property int batteryCritical: 5

    readonly property QtObject battery: QtObject {
        readonly property int low: root.batteryLow
        readonly property int critical: root.batteryCritical
    }

    // Wallpaper
    property string wallpaperPath: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    property int wallpaperIntervalMinutes: 30
    property bool wallpaperRunMatugen: true
    property string wallpaperTransition: "wipe"
    property real wallpaperTransitionDuration: 1.5
    property int wallpaperTransitionFps: 60
    property int wallpaperTransitionAngle: 30

    // Notifications
    property bool notifyTrackLowUrgency: true
    property real notifyTimeoutLow: 5000
    property real notifyTimeoutNormal: 8000
    property real notifyTimeoutCritical: -1
    property int notifyMaxPopups: 5
    property int notifyMaxCenterItems: 100

    // Usage Metrics
    property int usageMetricsPollInterval: 3000

    // Weather
    property string weatherLocation: ""

    // Time
    property string timeFormat: "hh:mm"
    property string dateFormat: "ddd dd"
    property string fullDateFormat: "ddd dd MMM, yyyy"

    property bool ready: false

    Component.onCompleted: initConfig()

    function initConfig() {
        checkConfigFile.running = true;
    }

    function applyConfig(data) {
        if (data.visualizer) {
            if (data.visualizer.bars !== undefined) root.visualizerBars = data.visualizer.bars;
            if (data.visualizer.fps !== undefined) root.visualizerFPS = data.visualizer.fps;
        }
        if (data.battery) {
            if (data.battery.low !== undefined) root.batteryLow = data.battery.low;
            if (data.battery.critical !== undefined) root.batteryCritical = data.battery.critical;
        }
        if (data.wallpaper) {
            if (data.wallpaper.path !== undefined) root.wallpaperPath = data.wallpaper.path.replace(/^~/, Quickshell.env("HOME"));
            if (data.wallpaper.intervalMinutes !== undefined) root.wallpaperIntervalMinutes = data.wallpaper.intervalMinutes;
            if (data.wallpaper.runMatugen !== undefined) root.wallpaperRunMatugen = data.wallpaper.runMatugen;
            if (data.wallpaper.transition !== undefined) root.wallpaperTransition = data.wallpaper.transition;
            if (data.wallpaper.transitionDuration !== undefined) root.wallpaperTransitionDuration = data.wallpaper.transitionDuration;
            if (data.wallpaper.transitionFps !== undefined) root.wallpaperTransitionFps = data.wallpaper.transitionFps;
            if (data.wallpaper.transitionAngle !== undefined) root.wallpaperTransitionAngle = data.wallpaper.transitionAngle;
        }
        if (data.notifications) {
            if (data.notifications.trackLowUrgency !== undefined) root.notifyTrackLowUrgency = data.notifications.trackLowUrgency;
            if (data.notifications.timeoutLow !== undefined) root.notifyTimeoutLow = data.notifications.timeoutLow;
            if (data.notifications.timeoutNormal !== undefined) root.notifyTimeoutNormal = data.notifications.timeoutNormal;
            if (data.notifications.timeoutCritical !== undefined) root.notifyTimeoutCritical = data.notifications.timeoutCritical;
            if (data.notifications.maxPopups !== undefined) root.notifyMaxPopups = data.notifications.maxPopups;
            if (data.notifications.maxCenterItems !== undefined) root.notifyMaxCenterItems = data.notifications.maxCenterItems;
        }
        if (data.usageMetrics) {
            if (data.usageMetrics.pollInterval !== undefined) root.usageMetricsPollInterval = data.usageMetrics.pollInterval;
        }
        if (data.weather) {
            if (data.weather.location !== undefined) root.weatherLocation = data.weather.location;
        }
        if (data.time) {
            if (data.time.format !== undefined) root.timeFormat = data.time.format;
            if (data.time.dateFormat !== undefined) root.dateFormat = data.time.dateFormat;
            if (data.time.fullDateFormat !== undefined) root.fullDateFormat = data.time.fullDateFormat;
        }
        root.ready = true;
    }

    Process {
        id: checkConfigFile
        running: false
        command: ["sh", "-c", `test -f "${root.configFilePath}" && echo exists || echo missing`]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() !== "exists") {
                    createConfigFile.running = true;
                }
            }
        }
    }

    Process {
        id: createConfigFile
        running: false
        command: ["sh", "-c", `mkdir -p "$(dirname "${root.configFilePath}")" && cat > "${root.configFilePath}" << 'EOF'
{
  "visualizer": {
    "bars": ${root.visualizerBars},
    "fps": ${root.visualizerFPS}
  },
  "battery": {
    "low": ${root.batteryLow},
    "critical": ${root.batteryCritical}
  },
  "wallpaper": {
    "path": "~/Pictures/Wallpapers",
    "intervalMinutes": 30,
    "runMatugen": true,
    "transition": "wipe",
    "transitionDuration": 1.5,
    "transitionFps": 60,
    "transitionAngle": 30
  },
  "notifications": {
    "trackLowUrgency": true,
    "timeoutLow": 5000,
    "timeoutNormal": 8000,
    "timeoutCritical": -1,
    "maxPopups": 5,
    "maxCenterItems": 100
  },
  "usageMetrics": {
    "pollInterval": 3000
  },
  "weather": {
    "location": ""
  },
  "time": {
    "format": "hh:mm",
    "dateFormat": "ddd dd",
    "fullDateFormat": "ddd dd MMM, yyyy"
  }
}
EOF`]
        onExited: (code) => {
            if (code === 0) {
                configFile.reload();
            }
        }
    }

    FileView {
        id: configFile
        path: "file://" + root.configFilePath
        watchChanges: true
        onFileChanged: configFile.reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                root.applyConfig(data);
            } catch (e) {
                print("[Settings] Failed to parse config: " + e);
            }
        }
    }
}
