pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import "../config"

Singleton {
    property bool isAvailable: UPower.displayDevice.isLaptopBattery
    property bool isFullyCharged: UPower.displayDevice.state == UPowerDeviceState.FullyCharged
    property bool isCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || UPower.displayDevice.state == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage
    property real estimatedTime: isCharging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty

    // derived
    property bool isLow: percentage <= Settings.battery.low / 100
    property bool isCritical: percentage <= Settings.battery.critical / 100
    property bool isLowAndNotCharging: isAvailable && isLow && !isCharging
    property bool isCriticalAndNotCharging: isAvailable && isCritical && !isCharging

    // power profiles integration
    property var activeProfile: PowerProfiles.profile
    property string profileIcon: {
        switch (activeProfile) {
        case PowerProfile.PowerSaver:
            return "󰌪";
        case PowerProfile.Balanced:
            return "󰘮";
        case PowerProfile.Performance:
            return "󰓅";
        default:
            print(activeProfile == PowerProfile.Performance);
            return "󰚦";
        }
    }

    function formatETA(seconds) {
        if ((seconds <= 0 || !isFinite(seconds)) && isFullyCharged)
            return "Fully Charged";

        const prefix = isCharging ? "Full in" : "Remaining";
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = Math.floor(seconds % 60);

        if (hours > 0) {
            if (minutes > 0) {
                return `${prefix}: ${hours}h ${minutes}m`;
            }
            return `${prefix}: ${hours}h`;
        }

        if (minutes > 0) {
            if (minutes >= 10 || remainingSeconds === 0) {
                return `${prefix}: ${minutes}m`;
            }
            return `${prefix}: ${minutes}m ${remainingSeconds}s`;
        }

        return `${prefix}: ${remainingSeconds}s`;
    }

    // Thermal throttling detection
    property bool thermalThrottling: PowerProfiles.degradationReason == PerformanceDegradationReason.HighTemperature

    // Function to set specific profile
    function setProfile(profileName) {
    }

    // TODO: add more interactions here (expose time to empty as undef, notification when charging stops, etc.)
    onIsLowAndNotChargingChanged: {
        if (isLowAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "Don't Panic" "This device is experiencing a temporary existence failure. Plugging it into a source of infinite improbability (or a wall socket) is recommended." -u normal -a "Shell"`]);
    }

    onIsCriticalAndNotChargingChanged: {
        if (isCriticalAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "SO LONG AND THANKS FOR ALL THE FISH" "This device is about to spontaneously cease existing. Hope you saved your work!" -u critical -a "quickshell"`]);
    }

    // Thermal throttling notification
    onThermalThrottlingChanged: {
        if (thermalThrottling)
            Quickshell.execDetached(["bash", "-c", `notify-send "Thermal Throttling" "System is reducing performance due to thermal constraints. Consider improving cooling or reducing workload." -u normal -a "quickshell"`]);
    }

    // Profile change notification (optional)
    onActiveProfileChanged: {
        var profileName = PowerProfile.toString(activeProfile);
        Quickshell.execDetached(["bash", "-c", `notify-send "Power Profile Changed" "Switched to ${profileName} mode ${profileIcon}" -u low -a "quickshell"`]);
    }
}
