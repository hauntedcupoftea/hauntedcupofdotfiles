pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "types" as Types

Singleton {
    id: root

    readonly property Types.Network indicators: Types.Network {}
    readonly property string status: indicators.noNetwork
    // This file will expose probably only 2 things, a string using nerdfonts that indicates bluetooth status (off/on/connected)
    // and a list of devices to connect to (i guess we also need a connectDevice(addr)
    Process {}
}
