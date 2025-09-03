pragma Singleton

import QtQuick

QtObject {
    readonly property bool debug: false // moves the bar a bit below in case waybar is enabled

    property string polarity: "dark" // or light TODO: change to enum

    // TODO: dhruv's idea: "focus mode" bool that toggles desktop background
    readonly property BatteryThresholds battery: BatteryThresholds {}
    readonly property int windowsThreshold: 4
    // edit this to tune how psychotic quickshell-kun gets
    readonly property list<string> sessionMessages: ["Session Menu", "pwease don't go ;-;", "I'll miss you if you leave...", "Are you sure you want to exit?", "We'll be waiting for your return!", "i will literally cut myself again if you leave", "Don't leave me, I'm scared.", "You're not allowed to leave.", "If you go, you'll regret it."]
    // edit this to choose which (problematic) tray icons are ignored by ID
    readonly property list<string> ignoredTrayItems: ["spotify-client"]
    readonly property int notificationWidth: 400
    readonly property real volumeChange: 5
    // speed of scrolling text
    property real pixelsPerSecond: 120
    property int visualizerBars: 16
    property int visualizerFPS: 60
    property bool envelopeScreen: false
    property bool roundedBar: true
}
