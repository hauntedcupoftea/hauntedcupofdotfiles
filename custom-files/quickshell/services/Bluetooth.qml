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
        if (!Bluetooth.defaultAdapter?.enabled)
            return indicators.powerOff;
        return indicators.powerOn;
    }
    // This file will expose probably only 2 things, a string using nerdfonts that indicates bluetooth status (off/on/connected)
    // and a list of devices to connect to (i guess we also need a connectDevice(addr)
}
