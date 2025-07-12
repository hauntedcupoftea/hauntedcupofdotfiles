pragma Singleton

import Quickshell
// import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick
import "types" as Types

Singleton {
    id: root

    readonly property Types.Bluetooth indicators: Types.Bluetooth {}
    readonly property string status: {
        // switch (Bluetooth.defaultAdapter.state) {
        // case BluetoothAdapterState.Disabled:
        //     print("Disabled");
        //     break;
        // case BluetoothAdapterState.Blocked:
        //     print("Blocked");
        //     break;
        // case BluetoothAdapterState.Enabled:
        //     print("Enabled");
        //     break;
        // case BluetoothAdapterState.Enabling:
        //     print("Enabling");
        //     break;
        // case BluetoothAdapterState.Disabling:
        //     print("Disabling");
        // }
        // print(Bluetooth.devices.values);
        // for (const item of Bluetooth.devices.values) {
        //     print(`${item.deviceName} ${item.connected}`);
        // }
        if ([BluetoothAdapterState.Blocked, BluetoothAdapterState.Disabled].includes(Bluetooth.defaultAdapter?.state))
            return indicators.powerOff;
        if (Bluetooth.devices?.values.filter(device => device.connected).length > 0)
            return indicators.connected;
        return indicators.powerOn;
    }
    // This file will expose probably only 2 things, a string using nerdfonts that indicates bluetooth status (off/on/connected)
    // and a list of devices to connect to (i guess we also need a connectDevice(addr)
}
