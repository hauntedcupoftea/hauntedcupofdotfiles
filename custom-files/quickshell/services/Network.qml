pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import "types" as Types

Singleton {
    id: root

    // type definitions
    readonly property Types.Network indicators: Types.Network {}

    // network state
    property bool hasEthernet: false
    property bool hasWifi: false
    property bool wifiEnabled: true
    property string networkName: ""
    property int signalStrength: 0
    property int updateInterval: 1000

    // available networks
    property var availableNetworks: []

    // status - main indicator to use
    readonly property string status: {
        if (!hasEthernet && !hasWifi)
            return indicators.noNetwork;
        if (hasEthernet)
            return indicators.ethernetEnabled;
        if (!wifiEnabled)
            return indicators.wifiOff;
        if (hasWifi) {
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
        return indicators.wifiOff;
    }

    // Update function
    function update() {
        connectionTypeProcess.running = true;
        networkNameProcess.running = true;
        signalStrengthProcess.running = true;
        wifiStateProcess.running = true;
        availableNetworksProcess.running = true;
    }

    // Timer for periodic updates
    Timer {
        interval: 100  // Start quickly
        running: true
        repeat: true
        onTriggered: {
            root.update();
            interval = root.updateInterval;  // Then slow down
        }
    }

    // Check connection types (ethernet/wifi)
    Process {
        id: connectionTypeProcess
        command: ["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "connection", "show", "--active"]

        property string buffer: ""

        stdout: SplitParser {
            onRead: data => {
                connectionTypeProcess.buffer += data;
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                connectionTypeProcess.buffer = "";
                return;
            }

            const lines = connectionTypeProcess.buffer.trim().split('\n');
            let ethernet = false;
            let wifi = false;

            lines.forEach(line => {
                if (line.includes("ethernet") || line.includes("802-3-ethernet")) {
                    ethernet = true;
                } else if (line.includes("wireless") || line.includes("802-11-wireless")) {
                    wifi = true;
                }
            });

            root.hasEthernet = ethernet;
            root.hasWifi = wifi;
            connectionTypeProcess.buffer = "";
        }
    }

    // Get active network name
    Process {
        id: networkNameProcess
        command: ["nmcli", "-t", "-f", "NAME", "connection", "show", "--active"]

        stdout: SplitParser {
            onRead: data => {
                const name = data.trim();
                if (name && name !== "lo") {
                    root.networkName = name;
                }
            }
        }
    }

    // Get WiFi signal strength
    Process {
        id: signalStrengthProcess
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\\*/{print $2}' | head -1"]

        stdout: SplitParser {
            onRead: data => {
                const signal = parseInt(data.trim());
                if (!isNaN(signal)) {
                    root.signalStrength = signal;
                }
            }
        }
    }

    // Check if WiFi is enabled
    Process {
        id: wifiStateProcess
        command: ["nmcli", "radio", "wifi"]

        stdout: SplitParser {
            onRead: data => {
                root.wifiEnabled = data.trim() === "enabled";
            }
        }
    }

    // Get available WiFi networks
    Process {
        id: availableNetworksProcess
        command: ["nmcli", "-g", "SSID,SIGNAL,SECURITY", "device", "wifi", "list"]

        property string buffer: ""

        stdout: StdioCollector {
            onStreamFinished: {
                availableNetworksProcess.buffer += this.text;
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                availableNetworksProcess.buffer = "";
                return;
            }

            const lines = availableNetworksProcess.buffer.trim().split('\n');
            let networks = [];

            lines.forEach(line => {
                const parts = line.split(':');
                if (parts.length >= 3) {
                    const ssid = parts[0].trim();
                    const signal = parseInt(parts[1]) || 0;
                    const security = parts[2].trim();

                    // Skip empty SSIDs and duplicates
                    if (ssid && !networks.some(n => n.ssid === ssid)) {
                        networks.push({
                            ssid: ssid,
                            signal: signal,
                            security: security,
                            isSecured: security !== "",
                            isConnected: ssid === root.networkName
                        });
                    }
                }
            });

            // Sort by signal strength (strongest first)
            networks.sort((a, b) => b.signal - a.signal);

            root.availableNetworks = networks;
            availableNetworksProcess.buffer = "";
        }
    }

    // Control processes
    Process {
        id: wifiControlProcess
        // command set dynamically in functions

        onExited: (exitCode, exitStatus) => {
            root.update();
            if (exitCode !== 0) {
                console.error("WiFi control command failed with exit code:", exitCode);
            }
        }
    }

    Process {
        id: connectionControlProcess
        // command set dynamically in functions

        onExited: (exitCode, exitStatus) => {
            root.update();
            if (exitCode === 0) {
                console.log("Connection command completed successfully");
            } else {
                console.error("Connection command failed with exit code:", exitCode);
            }
        }
    }

    // Public methods for control
    function enableWifi() {
        wifiControlProcess.command = ["nmcli", "radio", "wifi", "on"];
        wifiControlProcess.running = true;
    }

    function disableWifi() {
        wifiControlProcess.command = ["nmcli", "radio", "wifi", "off"];
        wifiControlProcess.running = true;
    }

    function connectToWifi(ssid, password) {
        if (password) {
            connectionControlProcess.command = ["nmcli", "device", "wifi", "connect", ssid, "password", password];
        } else {
            // Open network
            connectionControlProcess.command = ["nmcli", "device", "wifi", "connect", ssid];
        }
        connectionControlProcess.running = true;
    }

    function disconnectWifi() {
        connectionControlProcess.command = ["nmcli", "connection", "down", root.networkName];
        connectionControlProcess.running = true;
    }

    function refreshNetworks() {
        availableNetworksProcess.running = true;
    }
}
