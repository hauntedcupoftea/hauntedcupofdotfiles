pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs.config
import "types" as Types

Singleton {
    id: root

    readonly property Types.Network indicators: Types.Network {}

    readonly property string status: {
        if (!isConnected)
            return indicators.noNetwork;
        if (primaryType === "ethernet")
            return indicators.ethernetEnabled;
        if (!Networking.wifiEnabled)
            return indicators.wifiOff;
        if (signalStrength >= 80)
            return indicators.wifiStrength4;
        if (signalStrength >= 60)
            return indicators.wifiStrength3;
        if (signalStrength >= 40)
            return indicators.wifiStrength2;
        if (signalStrength >= 20)
            return indicators.wifiStrength1;
        return indicators.wifiAlert;
    }

    property bool wifiEnabled: Networking.wifiEnabled

    property WifiDevice _wifiDevice: null
    property WiredDevice _wiredDevice: null
    property WifiNetwork _connectedWifi: null

    property string primaryInterface: {
        if (_wiredDevice && _wiredDevice.hasLink)
            return _wiredDevice.name;
        if (_wifiDevice && _connectedWifi && _connectedWifi.connected)
            return _wifiDevice.name;
        return "";
    }

    property string primaryType: {
        if (_wiredDevice && _wiredDevice.hasLink)
            return "ethernet";
        if (_connectedWifi && _connectedWifi.connected)
            return "wifi";
        return "";
    }

    property bool isConnected: !(Networking.connectivity === NetworkConnectivity.None && Networking.connectivity === NetworkConnectivity.Unknown)

    property string ssid: _connectedWifi ? _connectedWifi.name : ""
    property int signalStrength: _connectedWifi ? Math.round(_connectedWifi.signalStrength * 100) : 0

    property var availableNetworks: []

    property real rxBytes: 0
    property real txBytes: 0
    property real rxRate: 0
    property real txRate: 0

    property int historySize: Settings.visualizerBars
    property var rxHistory: []
    property var txHistory: []
    property real maxRxRate: 1024 * 100
    property real maxTxRate: 1024 * 100

    readonly property real rxNormalized: Math.min(rxRate / maxRxRate, 1.0)
    readonly property real txNormalized: Math.min(txRate / maxTxRate, 1.0)

    property real lastRxBytes: 0
    property real lastTxBytes: 0
    property int updateInterval: 1000

    function getHistoryMax(arr, floor) {
        let max = floor;
        for (let i = 0; i < arr.length; i++) {
            if (arr[i] > max)
                max = arr[i];
        }
        return max;
    }

    function resetHistory() {
        rxHistory = new Array(historySize).fill(0);
        txHistory = new Array(historySize).fill(0);
        maxRxRate = 1024 * 100;
        maxTxRate = 1024 * 100;
    }

    onHistorySizeChanged: resetHistory()

    function formatRate(bytesPerSecond) {
        const rate = Math.abs(bytesPerSecond);
        if (rate >= 1024 * 1024 * 1024)
            return `${(rate / (1024 * 1024 * 1024)).toFixed(1)} GB/s`;
        if (rate >= 1024 * 1024)
            return `${(rate / (1024 * 1024)).toFixed(1)} MB/s`;
        if (rate >= 1024)
            return `${(rate / 1024).toFixed(1)} KB/s`;
        return `${rate.toFixed(0)} B/s`;
    }

    Component.onCompleted: {
        root.resetHistory();
        print(`[Network] init: backend=${NetworkBackendType.toString(Networking.backend)} devices=${Networking.devices.values.length}`);
        root._rescanDevices();
    }

    Connections {
        target: Networking.devices

        function onValuesChanged() {
            print(`[Network] device list changed: count=${Networking.devices.values.length}`);
            root._rescanDevices();
        }
    }

    function _rescanDevices() {
        let wifi = null;
        let wired = null;

        for (let i = 0; i < Networking.devices.values.length; i++) {
            const dev = Networking.devices.values[i];
            print(`[Network] device: ${dev.name} type=${DeviceType.toString(dev.type)}`);

            if (dev.type === DeviceType.Wifi && !wifi) {
                wifi = dev;
                dev.scannerEnabled = true;
            } else if (dev.type === DeviceType.Wired && !wired) {
                wired = dev;
            }
        }

        if (wifi !== root._wifiDevice) {
            root._wifiDevice = wifi;
            root._onNetworksChanged();
        }
        if (wired !== root._wiredDevice) {
            root._wiredDevice = wired;
        }
    }

    // -- Reactive: wifi networks model changes --

    Connections {
        target: root._wifiDevice ? root._wifiDevice.networks : null

        function onValuesChanged() {
            root._onNetworksChanged();
        }
    }

    function _onNetworksChanged() {
        root._connectedWifi = root._findConnectedWifi();
        root._buildNetworkList();
    }

    function _findConnectedWifi() {
        if (!root._wifiDevice)
            return null;
        for (let i = 0; i < root._wifiDevice.networks.values.length; i++) {
            let net = root._wifiDevice.networks.values[i];
            if (net instanceof WifiNetwork && net.connected) {
                print(`[Network] wifi connected: ${net.name} sig=${Math.round(net.signalStrength * 100)}%`);
                return net;
            }
        }
        return null;
    }

    // -- Reactive: wifi device connection state changes --

    Connections {
        target: root._wifiDevice

        function onConnectedChanged() {
            print(`[Network] wifi device connected=${root._wifiDevice?.connected}`);
            root._connectedWifi = root._findConnectedWifi();
        }
    }

    // -- Reactive: watch the currently connected wifi network for disconnection --

    Connections {
        target: root._connectedWifi

        function onConnectedChanged() {
            if (!root._connectedWifi || !root._connectedWifi.connected) {
                print(`[Network] wifi disconnected: ${root._connectedWifi?.name}`);
                root._connectedWifi = root._findConnectedWifi();
            }
        }
    }

    // -- Reactive: wired link changes --

    Connections {
        target: root._wiredDevice

        function onHasLinkChanged() {
            print(`[Network] wired hasLink=${root._wiredDevice?.hasLink} speed=${root._wiredDevice?.linkSpeed}`);
        }
    }

    // -- Available networks list --

    function _buildNetworkList() {
        if (!root._wifiDevice) {
            root.availableNetworks = [];
            return;
        }
        let list = [];
        for (let i = 0; i < root._wifiDevice.networks.values.length; i++) {
            let net = root._wifiDevice.networks.values[i];
            if (net instanceof WifiNetwork && net.name) {
                list.push({
                    ssid: net.name,
                    signal: Math.round(net.signalStrength * 100),
                    security: WifiSecurityType.toString(net.security),
                    isSecured: net.security !== WifiSecurityType.Open,
                    isConnected: net.connected
                });
            }
        }
        list.sort((a, b) => b.signal - a.signal);
        root.availableNetworks = list;
        print(`[Network] scan: ${list.length} networks visible`);
    }

    Timer {
        interval: root.updateInterval
        running: root.primaryInterface !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: trafficReader.running = true
    }

    Process {
        id: trafficReader
        command: ["sh", "-c", `
            RX=$(cat /sys/class/net/${root.primaryInterface}/statistics/rx_bytes 2>/dev/null || echo 0)
            TX=$(cat /sys/class/net/${root.primaryInterface}/statistics/tx_bytes 2>/dev/null || echo 0)
            echo "$RX $TX"
        `]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ");
                if (parts.length !== 2)
                    return;

                const rx = parseInt(parts[0]) || 0;
                const tx = parseInt(parts[1]) || 0;

                if (root.lastRxBytes > 0) {
                    const interval = root.updateInterval / 1000.0;
                    root.rxRate = (rx - root.lastRxBytes) / interval;
                    root.txRate = (tx - root.lastTxBytes) / interval;

                    let newRxHistory = root.rxHistory.slice(1).concat([root.rxRate]);
                    let newTxHistory = root.txHistory.slice(1).concat([root.txRate]);
                    while (newRxHistory.length < root.historySize)
                        newRxHistory.unshift(0);
                    while (newTxHistory.length < root.historySize)
                        newTxHistory.unshift(0);

                    root.rxHistory = newRxHistory;
                    root.txHistory = newTxHistory;

                    const minFloor = 1024 * 100;
                    root.maxRxRate = root.getHistoryMax(root.rxHistory, minFloor);
                    root.maxTxRate = root.getHistoryMax(root.txHistory, minFloor);
                }

                root.rxBytes = rx;
                root.txBytes = tx;
                root.lastRxBytes = rx;
                root.lastTxBytes = tx;
            }
        }
    }

    function enableWifi() {
        print(`[Network] wifi enabling`);
        Networking.wifiEnabled = true;
    }
    function disableWifi() {
        print(`[Network] wifi disabling`);
        Networking.wifiEnabled = false;
    }
    function toggleWifi() {
        print(`[Network] wifi toggle`);
        Networking.wifiEnabled = (!Networking.wifiEnabled);
    }

    function connectToWifi(ssid, password) {
        print(`[Network] connecting to ${ssid}${password ? ' (with PSK)' : ''}`);
        if (!root._wifiDevice) {
            print(`[Network] cannot connect: no wifi device`);
            return;
        }
        for (let i = 0; i < root._wifiDevice.networks.values.length; i++) {
            let net = root._wifiDevice.networks.values[i];
            if (net instanceof WifiNetwork && net.name === ssid) {
                if (password)
                    net.connectWithPsk(password);
                else
                    net.connect();
                return;
            }
        }
        print(`[Network] network ${ssid} not found in scan results`);
    }

    function disconnect() {
        print(`[Network] disconnecting all devices`);
        root._wifiDevice?.disconnect();
        root._wiredDevice?.disconnect();
    }

    function rescan() {
        print(`[Network] rescan requested`);
        if (root._wifiDevice)
            root._wifiDevice.scannerEnabled = true;
    }
}
