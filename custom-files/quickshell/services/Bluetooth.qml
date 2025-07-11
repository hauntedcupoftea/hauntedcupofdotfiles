pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string bluetoothIndicator
    // This file will expose probably only 2 things, a string using nerdfonts that indicates bluetooth status (off/on/connected)
    // and a list of devices to connect to (i guess we also need a connectDevice(addr)
}
