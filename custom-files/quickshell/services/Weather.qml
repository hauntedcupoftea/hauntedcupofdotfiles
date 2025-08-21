pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string loc
    property var cc
    property var forecast
    property bool isLoading: false

    readonly property string icon: cc ? weatherIcons[cc.weatherCode] : "󰧠"
    readonly property string description: cc?.weatherDesc[0].value ?? qsTr("Weather unavailable")
    readonly property string temp: `${cc?.temp_C ?? 0}°C`
    readonly property string feelsLike: `${cc?.FeelsLikeC ?? 0}°C`
    readonly property int humidity: cc?.humidity ?? 0

    readonly property var weatherIcons: {
        "113": "󰖙",
        "116": "󰖕",
        "119": "󰖐",
        "122": "󰖐",
        "143": "󰖑",
        "176": "󰖗",
        "179": "󰙿",
        "182": "󰙿",
        "185": "󰙿",
        "200": "󰖓",
        "227": "󰖘",
        "230": "󰼶",
        "248": "󰖑",
        "260": "󰖑",
        "263": "󰖗",
        "266": "󰖗",
        "281": "󰖖",
        "284": "󰖖",
        "293": "󰖗",
        "296": "󰖗",
        "299": "󰖖",
        "302": "󰖖",
        "305": "󰖒",
        "308": "󰖒",
        "311": "󰙿",
        "314": "󰙿",
        "317": "󰙿",
        "320": "󰖘",
        "323": "󰖘",
        "326": "󰖘",
        "329": "󰼶",
        "332": "󰼶",
        "335": "󰼶",
        "338": "󰼶",
        "350": "󰖒",
        "353": "󰖗",
        "356": "󰖗",
        "359": "󰖒",
        "362": "󰙿",
        "365": "󰙿",
        "368": "󰖘",
        "371": "󰼶",
        "374": "󰙿",
        "377": "󰙿",
        "386": "󰙾",
        "389": "󰙾",
        "392": "󰙾",
        "395": "󰼶"
    }

    function fetchLocation(): void {
        if (isLoading) {
            waitTimer.start();
            return;
        }

        isLoading = true;

        locationFetcher.running = true;
    }

    function fetchWeather(): void {
        if (!loc)
            return;

        if (isLoading) {
            waitTimer.start();
            return;
        }

        isLoading = true;

        weatherFetcher.running = true;
    }

    Process {
        id: locationFetcher
        command: ["curl", "-s", "-L", "--max-time", "10", "https://ipinfo.io/json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const locationData = JSON.parse(text);
                    const newLoc = locationData.loc ?? "";
                    root.isLoading = false;

                    if (newLoc !== root.loc) {
                        root.loc = newLoc;
                        timer.restart();
                    }
                } catch (e) {
                    print("locationFetcher failed", e);
                    root.isLoading = false;
                }
            }
        }
    }

    Process {
        id: weatherFetcher
        command: ["curl", "-s", "-L", "--max-time", "15", `https://wttr.in/${root.loc}?format=j1`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.isLoading = false;

                if (text.includes("<html>") || text.includes("<!DOCTYPE")) {
                    return;
                }

                if (text.includes("Sorry") || text.includes("Error") || text.includes("404")) {
                    return;
                }

                try {
                    const json = JSON.parse(text.trim());
                    if (json.current_condition && json.current_condition.length > 0) {
                        root.cc = json.current_condition[0];
                        root.forecast = json.weather || [];
                    } else {}
                } catch (e) {
                    print("weatherfetcher failed", e);
                    root.isLoading = false;
                }
            }
        }
    }

    onLocChanged: {
        if (loc) {
            fetchWeather();
        }
    }

    Component.onCompleted: reload()

    Timer {
        id: waitTimer
        interval: 500
        repeat: false

        property bool retryLocation: false
        property bool retryWeather: false

        onTriggered: {
            if (!root.isLoading) {
                if (retryLocation) {
                    retryLocation = false;
                    root.fetchLocation();
                } else if (retryWeather) {
                    retryWeather = false;
                    root.fetchWeather();
                }
            } else {
                start();
            }
        }
    }

    function reload(): void {
        if (!loc || timer.elapsed() > 900) {
            if (isLoading) {
                waitTimer.retryLocation = true;
                waitTimer.start();
            } else {
                fetchLocation();
            }
        }
    }

    ElapsedTimer {
        id: timer
    }
}
