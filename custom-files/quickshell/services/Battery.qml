pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import "../config"

Singleton {
    property bool isAvailable: UPower.displayDevice.isLaptopBattery
    property bool isCharging: UPower.displayDevice.state == UPowerDeviceState.Charging || UPowerDeviceState.FullyCharged
    property bool isPluggedIn: isCharging || UPower.displayDevice.state == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage

    property bool isLow: percentage <= Settings.battery.low / 100
    property bool isCritical: percentage <= Settings.battery.critical / 100

    property bool isLowAndNotCharging: isAvailable && isLow && !isCharging
    property bool isCriticalAndNotCharging: isAvailable && isCritical && !isCharging

    // TODO: add more interactions here (expose time to empty as undef, notification when charging stops, etc.)

    onIsLowAndNotChargingChanged: {
        if (isLowAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "Don't Panic" "This device is experiencing a temporary existence failure. Plugging it into a source of infinite improbability (or a wall socket) is recommended." -u normal -a "Shell"`]);
    }

    onIsCriticalAndNotChargingChanged: {
        if (isCriticalAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "SO LONG AND THANKS FOR ALL THE FISH" "This device is about to spontaneously cease existing. Hope you saved your work!" -u critical -a "quickshell"`]);
    }
}
