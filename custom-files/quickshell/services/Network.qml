pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import "types" as Types

Singleton {
    id: root

    readonly property Types.Network indicators: Types.Network {}
    property var availableNetworks: []

    readonly property string status: {
        console.log(signalStrength);
        if (!isConnected)
            return indicators.noNetwork;
        if (primaryType === "ethernet")
            return indicators.ethernetEnabled;
        if (!wifiEnabled)
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

    property string primaryInterface: ""
    property string primaryType: ""
    property bool isConnected: false

    property string ssid: ""
    property int signalStrength: 0
    property bool wifiEnabled: true

    property real rxBytes: 0
    property real txBytes: 0
    property real rxRate: 0
    property real txRate: 0  // bytes per second

    property int historySize: Settings.visualizerBars
    property var rxHistory: []
    property var txHistory: []

    property real maxRxRate: 1024 * 100 // Min floor 100 KB/s
    property real maxTxRate: 1024 * 100

    readonly property real rxNormalized: Math.min(rxRate / maxRxRate, 1.0)
    readonly property real txNormalized: Math.min(txRate / maxTxRate, 1.0)

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
    Component.onCompleted: resetHistory()

    property real lastRxBytes: 0
    property real lastTxBytes: 0
    property int updateInterval: 1000

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

    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            interfaceDetector.running = true;
            if (root.primaryInterface) {
                trafficReader.running = true;
            }
            if (root.primaryType === "wifi") {
                wifiInfoReader.running = true;
            }
        }
    }

    Process {
        id: interfaceDetector
        command: ["sh", "-c", "ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \\K\\S+' | head -1"]
        stdout: SplitParser {
            onRead: data => {
                const iface = data.trim();
                if (iface && iface !== root.primaryInterface) {
                    root.primaryInterface = iface;
                    typeDetector.running = true;
                    root.resetHistory();
                }
                root.isConnected = Boolean(iface);
            }
        }
    }

    Process {
        id: typeDetector
        command: ["sh", "-c", `[ -d /sys/class/net/${root.primaryInterface}/wireless ] && echo "wifi" || echo "ethernet"`]
        stdout: SplitParser {
            onRead: data => root.primaryType = data.trim()
        }
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

                    const minFloor = 1024 * 100; // 100 KB/s floor
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

    Process {
        id: wifiInfoReader
        command: ["sh", "-c", `
            nmcli -t -f IN-USE,SSID,SIGNAL dev wifi list ifname ${root.primaryInterface} --rescan no 2>/dev/null | \
            grep '^\*:' | \
            sed -E 's/^\\*:(.*):([0-9]+)$/\\1|\\2/' || echo "|0"
        `]

        stdout: SplitParser {
            onRead: data => {
                const text = data.trim();
                const separator = text.lastIndexOf("|");

                if (separator !== -1) {
                    root.ssid = text.substring(0, separator);
                    root.signalStrength = parseInt(text.substring(separator + 1)) || 0;
                }
            }
        }
    }

    Process {
        id: wifiStateChecker
        command: ["nmcli", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => root.wifiEnabled = data.trim() === "enabled"
        }
    }

    Timer {
        interval: 10000
        running: root.primaryType === "wifi"
        repeat: true
        triggeredOnStart: true
        onTriggered: networkScanner.running = true
    }

    Process {
        id: networkScanner
        command: ["nmcli", "-g", "SSID,SIGNAL,SECURITY", "device", "wifi", "list"]

        property string buffer: ""

        stdout: StdioCollector {
            onStreamFinished: {
                networkScanner.buffer += this.text;
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                networkScanner.buffer = "";
                return;
            }

            const lines = networkScanner.buffer.trim().split('\n');
            let networks = [];

            lines.forEach(line => {
                const parts = line.split(':');
                if (parts.length >= 3) {
                    const ssid = parts[0].trim();
                    const signal = parseInt(parts[1]) || 0;
                    const security = parts[2].trim();

                    if (ssid && !networks.some(n => n.ssid === ssid)) {
                        networks.push({
                            ssid: ssid,
                            signal: signal,
                            security: security,
                            isSecured: security !== "",
                            isConnected: ssid === root.ssid
                        });
                    }
                }
            });

            networks.sort((a, b) => b.signal - a.signal);
            root.availableNetworks = networks;
            networkScanner.buffer = "";
        }
    }

    function enableWifi() {
        controlProcess.command = ["nmcli", "radio", "wifi", "on"];
        controlProcess.running = true;
    }

    function disableWifi() {
        controlProcess.command = ["nmcli", "radio", "wifi", "off"];
        controlProcess.running = true;
    }

    function connectToWifi(ssid, password) {
        if (password) {
            controlProcess.command = ["nmcli", "device", "wifi", "connect", ssid, "password", password];
        } else {
            controlProcess.command = ["nmcli", "device", "wifi", "connect", ssid];
        }
        controlProcess.running = true;
    }

    function disconnect() {
        controlProcess.command = ["nmcli", "device", "disconnect", root.primaryInterface];
        controlProcess.running = true;
    }

    Process {
        id: controlProcess
        onExited: (exitCode, exitStatus) => {
            interfaceDetector.running = true;
        }
    }
}
