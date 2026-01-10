pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import QtQuick
import "types" as Types

Singleton {
    id: root

    readonly property Types.Bluetooth indicators: Types.Bluetooth {}

    readonly property bool isEnabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property bool isBlocked: Bluetooth.defaultAdapter?.state === BluetoothAdapterState.Blocked
    readonly property bool isDiscovering: Bluetooth.defaultAdapter?.discovering ?? false
    readonly property bool isPairable: Bluetooth.defaultAdapter?.pairable ?? false

    readonly property var devices: Bluetooth.devices?.values ?? []
    readonly property var connectedDevices: devices.filter(device => device.connected)
    readonly property int deviceCount: connectedDevices.length

    readonly property string status: {
        if (isBlocked || !isEnabled)
            return indicators.powerOff;
        if (deviceCount > 0)
            return indicators.connected;
        return indicators.powerOn;
    }

    function togglePower() {
        if (!Bluetooth.defaultAdapter)
            return;
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
    }

    function startDiscovery() {
        if (!Bluetooth.defaultAdapter || isDiscovering)
            return;
        Bluetooth.defaultAdapter.discovering = true;
    }

    function stopDiscovery() {
        if (!Bluetooth.defaultAdapter || !isDiscovering)
            return;
        Bluetooth.defaultAdapter.discovering = false;
    }

    function toggleDiscovery() {
        if (!Bluetooth.defaultAdapter)
            return;
        Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering;
    }
}
