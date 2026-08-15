pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

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

    // GPU
    property real gpuTemp: 0
    property real gpuUsage: 0
    property real gpuMemUsed: 0
    property real gpuMemTotal: 1
    readonly property real gpuMemPerc: gpuMemTotal > 0 ? gpuMemUsed / gpuMemTotal : 0
    property string gpuName: ""
    property bool gpuAvailable: false

    property int refCount: 0

    Timer {
        running: root.refCount > 0
        interval: Settings.usageMetricsPollInterval
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

            # Memory
            MEM_TOTAL=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
            MEM_AVAIL=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
            MEM_USED=$((MEM_TOTAL - MEM_AVAIL))

            # CPU Temperature - sysfs hwmon (k10temp/amd, coretemp/intel)
            CPU_TEMP=0
            for hwmon_dir in /sys/class/hwmon/hwmon*/; do
                name=$(cat "\${hwmon_dir}name" 2>/dev/null)
                case "$name" in
                    k10temp|coretemp|zenpower|cpu_thermal)
                        raw=$(cat "$\{hwmon_dir}temp1_input" 2>/dev/null)
                        [ -n "$raw" ] && CPU_TEMP=$(echo "scale=1; $raw/1000" | bc -l 2>/dev/null) && break
                        ;;
                esac
            done

            # Fallback: sensors text output
            if [ "$CPU_TEMP" = "0" ] || [ -z "$CPU_TEMP" ]; then
                CPU_TEMP=$(sensors 2>/dev/null | awk '
                    /Package id 0:/ || /Tdie:/ || /Tctl:/ || /Tccd/ {
                        gsub(/[+°C]/, "", $4); print $4; exit
                    }
                ' || echo 0)
            fi

            # Storage
            DF_OUTPUT=$(df -k | grep '^/dev/' | awk '!seen[$1]++ {used+=$3; total+=$2} END {print used, total}')
            STORAGE_USED=$(echo "$DF_OUTPUT" | awk '{print $1}')
            STORAGE_TOTAL=$(echo "$DF_OUTPUT" | awk '{print $2}')

            # GPU
            GPU_TEMP=0
            GPU_USAGE=0
            GPU_MEM_USED=0
            GPU_MEM_TOTAL=0
            GPU_NAME=""

            # Try NVIDIA
            if command -v nvidia-smi &>/dev/null; then
                data=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
                if [ -n "$data" ]; then
                    IFS=', ' read -r gt gu gmu gmt <<< "$data"
                    GPU_TEMP=\${gt:-0}
                    GPU_USAGE=\${gu:-0}
                    GPU_MEM_USED=\${gmu:-0}
                    GPU_MEM_TOTAL=$\{gmt:-1}
                    GPU_NAME="nvidia"
                fi
            fi

            # Try AMD
            if [ -z "$GPU_NAME" ]; then
                for drm in /sys/class/drm/card*; do
                    [ ! -d "$drm/device" ] && continue
                    driver=$(readlink "$drm/device/driver" 2>/dev/null)
                    driver=$(basename "$driver" 2>/dev/null)
                    [ "$driver" != "amdgpu" ] && [ "$driver" != "radeon" ] && continue

                    GPU_NAME="amd"

                    for hwmon_dir in "$drm/device/hwmon/hwmon"*/; do
                        [ ! -d "$hwmon_dir" ] && continue
                        for i in 1 2 3; do
                            label=$(cat "\${hwmon_dir}temp\${i}_label" 2>/dev/null)
                            raw=$(cat "\${hwmon_dir}temp\${i}_input" 2>/dev/null)
                            [ -z "$raw" ] && continue
                            case "$label" in
                                edge|junction|"GPU"*|"Hot Spot"*)
                                    temp=$(echo "scale=1; $raw/1000" | bc -l 2>/dev/null)
                                    [ -n "$temp" ] && GPU_TEMP=$temp
                                    ;;
                            esac
                        done
                        break
                    done

                    # Try rocm-smi for AMD usage/memory
                    if command -v rocm-smi &>/dev/null; then
                        rsmi=$(rocm-smi --showuse --showmeminfo vram 2>/dev/null)
                        GPU_USAGE=$(echo "$rsmi" | grep "GPU use" | awk '{print $NF}' | tr -d '%' | head -1 | grep -o '[0-9.]*' || echo 0)
                        vram_line=$(echo "$rsmi" | grep "VRAM" | head -1)
                        GPU_MEM_USED=$(echo "$vram_line" | awk '{print $3}' | grep -o '[0-9.]*' || echo 0)
                        GPU_MEM_TOTAL=$(echo "$vram_line" | awk '{print $5}' | grep -o '[0-9.]*' || echo 0)
                    fi

                    break
                done
            fi

            [ -z "$GPU_MEM_TOTAL" ] || [ "$GPU_MEM_TOTAL" = "0" ] && GPU_MEM_TOTAL=1

            echo "{"
            echo "  \\"cpu_line\\": \\"$CPU_LINE\\","
            echo "  \\"mem_used\\": \${MEM_USED:-0},"
            echo "  \\"mem_total\\": \${MEM_TOTAL:-1},"
            echo "  \\"cpu_temp\\": \${CPU_TEMP:-0},"
            echo "  \\"storage_used\\": \${STORAGE_USED:-0},"
            echo "  \\"storage_total\\": \${STORAGE_TOTAL:-1},"
            echo "  \\"gpu_temp\\": \${GPU_TEMP:-0},"
            echo "  \\"gpu_usage\\": \${GPU_USAGE:-0},"
            echo "  \\"gpu_mem_used\\": \${GPU_MEM_USED:-0},"
            echo "  \\"gpu_mem_total\\": \${GPU_MEM_TOTAL:-1},"
            echo "  \\"gpu_name\\": \\"$GPU_NAME\\""
            echo "}"
        `]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);

                    const stats = data.cpu_line.split(/\s+/);
                    const numbers = stats.slice(1).map(n => parseInt(n, 10) || 0);
                    if (numbers.length > 4) {
                        const total = numbers.reduce((a, b) => a + b, 0);
                        const idle = numbers[3] + numbers[4];
                        const totalDiff = total - root.lastCpuTotal;
                        const idleDiff = idle - root.lastCpuIdle;
                        root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
                        root.lastCpuTotal = total;
                        root.lastCpuIdle = idle;
                    }
                    root.memUsed = data.mem_used;
                    root.memTotal = data.mem_total;
                    root.cpuTemp = parseFloat(data.cpu_temp);
                    root.storageUsed = data.storage_used;
                    root.storageTotal = data.storage_total;

                    root.gpuTemp = parseFloat(data.gpu_temp);
                    root.gpuUsage = parseFloat(data.gpu_usage);
                    root.gpuMemUsed = parseFloat(data.gpu_mem_used);
                    root.gpuMemTotal = parseFloat(data.gpu_mem_total);
                    root.gpuName = data.gpu_name || "";
                    root.gpuAvailable = root.gpuName !== "";
                } catch (e) {
                    console.error("Failed to parse system metrics:", e, text);
                }
            }
        }
    }

    property real lastCpuIdle: 0
    property real lastCpuTotal: 0

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
