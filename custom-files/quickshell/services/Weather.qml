pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.theme

Singleton {
    id: root

    property string loc
    property var cc
    property var forecast
    property bool isLoading: false
    property string locationName
    property var lastUpdated: new Date()

    // --- Visual Properties ---
    readonly property string icon: cc ? weatherIcons[cc.weatherCode] : "󰧠"
    readonly property string description: cc ? cc.weatherDesc[0].value : "Unknown"
    readonly property string temp: cc ? cc.temp_C : "0"
    readonly property string feelsLike: cc ? cc.FeelsLikeC : "0"
    readonly property int humidity: cc ? cc.humidity : 0
    readonly property string windSpeed: cc ? cc.windspeedKmph : "0"

    readonly property color conditionColor: {
        if (!cc)
            return Theme.colors.surface_container;
        const code = parseInt(cc.weatherCode);

        if (code === 113)
            return "#F59E0B"; // Sunny
        if ([116, 119, 122, 143, 248, 260].includes(code))
            return "#6B7280"; // Cloudy
        if ([176, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 350, 353, 356, 359].includes(code))
            return "#3B82F6"; // Rain
        if ([179, 182, 185, 227, 230, 320, 323, 326, 329, 332, 335, 338, 368, 371, 395].includes(code))
            return "#A5F3FC"; // Snow
        if ([200, 386, 389, 392].includes(code))
            return "#7C3AED"; // Thunder

        return Theme.colors.primary;
    }

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

    function fetchLocation() {
        if (isLoading) {
            print("Weather: Skipped fetchLocation (Already loading)");
            return;
        }
        print("Weather: Fetching Location...");
        isLoading = true;
        locationFetcher.running = true;
    }

    function fetchWeather() {
        if (!loc) {
            print("Weather: Skipped fetchWeather (No location)");
            fetchLocation();
            return;
        }

        if (isLoading) {
            print("Weather: Skipped fetchWeather (Already loading)");
            return;
        }

        print("Weather: Fetching Weather for " + loc + "...");
        isLoading = true;
        weatherFetcher.running = true;
    }

    function reload() {
        print("Weather: Reload requested");
        isLoading = false;
        if (!loc)
            fetchLocation();
        else
            fetchWeather();
    }

    Component.onCompleted: {
        print("Weather Service: Started");
        fetchLocation();
    }

    Process {
        id: locationFetcher
        command: ["curl", "-s", "-L", "--max-time", "10", "https://ipinfo.io/json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    print("Weather: Location data received.");
                    const data = JSON.parse(text);

                    if (data.loc) {
                        print("Weather: Location found: " + data.city);
                        root.loc = data.loc;
                        root.locationName = data.city;

                        // IMPORTANT: Reset loading so fetchWeather can run
                        root.isLoading = false;
                        root.fetchWeather();
                    } else {
                        print("Weather: Location data missing 'loc'");
                        root.isLoading = false;
                    }
                } catch (e) {
                    print("Weather Error (Location): " + e);
                    print("Raw Output: " + text);
                    root.isLoading = false;
                }
            }
        }

        onExited: code => {
            if (code !== 0) {
                print("Weather: Location fetcher exited with code " + code);
                root.isLoading = false;
            }
        }
    }

    Process {
        id: weatherFetcher
        command: ["curl", "-s", "-L", "-H", "User-Agent: curl/7.68.0", "--max-time", "10", `https://wttr.in/${root.loc}?format=j1`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    print("Weather: Weather data received.");
                    if (text.trim().startsWith("<") || text.includes("Sorry")) {
                        throw "Invalid response (HTML/Text)";
                    }

                    const json = JSON.parse(text.trim());

                    if (json.current_condition && json.current_condition[0]) {
                        root.cc = json.current_condition[0];
                        root.forecast = json.weather || [];
                        root.lastUpdated = new Date();
                        print("Weather: Updated successfully.");
                    } else {
                        print("Weather: JSON structure unexpected.");
                    }
                } catch (e) {
                    print("Weather Error (Weather): " + e);
                    if (text.length < 500)
                        print("Raw: " + text);
                }
                root.isLoading = false;
            }
        }

        onExited: code => {
            if (code !== 0) {
                print("Weather: Weather fetcher exited with code " + code);
                root.isLoading = false;
            }
        }
    }
}
