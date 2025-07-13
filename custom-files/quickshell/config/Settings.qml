pragma Singleton

import QtQuick

QtObject {
    readonly property bool debug: false // moves the bar a bit below in case waybar is enabled
    // TODO: dhruv's idea: "focus mode" bool that toggles desktop background
    readonly property BatteryThresholds battery: BatteryThresholds {}
}
