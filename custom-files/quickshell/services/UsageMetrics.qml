pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real systemActivity: (cpuPerc * 0.8) + (memPerc * 0.2)
    property real cpuPerc: 0
    property real cpuTemp: 0
    property real memUsed: 0
    property real memTotal: 1
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0
    property real storageUsed: 0
    property real storageTotal: 1
    readonly property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    property int refCount: 0

    Timer {
        running: root.refCount > 0
        interval: 3000
        repeat: true
        onTriggered: {
            dataFetcher.running = true;
        }
    }

    Process {
        id: dataFetcher

        command: ["sh", "-c", `
            # CPU Usage
            CPU_LINE=$(head -n 1 /proc/stat)

            # Memory Usage
            MEM_TOTAL=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
            MEM_AVAIL=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
            MEM_USED=$((MEM_TOTAL - MEM_AVAIL))

            # CPU Temp
            CPU_TEMP=$(sensors | grep -E '(Package id 0|Tdie|Tctl):' | head -n 1 | awk '{print $4}' | sed 's/+//;s/°C//')

            # Storage
            DF_OUTPUT=$(df -k | grep '^/dev/' | awk '{used+=$3; total+=$2} END {print used, total}')
            STORAGE_USED=$(echo $DF_OUTPUT | awk '{print $1}')
            STORAGE_TOTAL=$(echo $DF_OUTPUT | awk '{print $2}')

            # Output everything as a single JSON object
            echo "{"
            echo "  \\"cpu_line\\": \\"$CPU_LINE\\","
            echo "  \\"mem_used\\": \${MEM_USED:-0},"
            echo "  \\"mem_total\\": \${MEM_TOTAL:-1},"
            echo "  \\"cpu_temp\\": \${CPU_TEMP:-0},"
            echo "  \\"storage_used\\": \${STORAGE_USED:-0},"
            echo "  \\"storage_total\\": \${STORAGE_TOTAL:-1}"
            echo "}"
        `]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);

                    const stats = data.cpu_line.split(/\s+/);
                    const numbers = stats.slice(1).map(n => parseInt(n, 10) || 0);
                    if (numbers.length > 4) {
                        // IMPORTANT: Sum ALL numbers for the total, not just the first few.
                        const total = numbers.reduce((a, b) => a + b, 0);

                        // A more accurate idle time is the sum of the 'idle' and 'iowait' fields.
                        // These are the 4th and 5th values (index 3 and 4).
                        const idle = numbers[3] + numbers[4];

                        const totalDiff = total - root.lastCpuTotal;
                        const idleDiff = idle - root.lastCpuIdle;

                        // This calculation is now correct.
                        root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                        // Update the state for the next calculation.
                        root.lastCpuTotal = total;
                        root.lastCpuIdle = idle;
                    }
                    root.memUsed = data.mem_used;
                    root.memTotal = data.mem_total;
                    root.cpuTemp = parseFloat(data.cpu_temp);
                    root.storageUsed = data.storage_used;
                    root.storageTotal = data.storage_total;
                } catch (e) {
                    console.error("Failed to parse system metrics:", e, text);
                }
            }
        }
    }

    property real lastCpuIdle: 0
    property real lastCpuTotal: 0

    // thanks sora
    function formatKib(kib: real): var {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib)
            return {
                value: kib / tib,
                unit: "TiB"
            };
        if (kib >= gib)
            return {
                value: kib / gib,
                unit: "GiB"
            };
        if (kib >= mib)
            return {
                value: kib / mib,
                unit: "MiB"
            };
        return {
            value: kib,
            unit: "KiB"
        };
    }
}
