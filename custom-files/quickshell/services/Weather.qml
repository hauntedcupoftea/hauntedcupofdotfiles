pragma Singleton

import Quickshell
import QtQuick
import qs.utils

Singleton {
    id: root

    property string loc
    property var cc
    property var forecast
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

    function reload(): void {
        if (!loc || timer.elapsed() > 900)
            Requests.get("https://ipinfo.io/json", text => {
                loc = JSON.parse(text).loc ?? "";
                timer.restart();
            });
    }

    onLocChanged: Requests.get(`https://wttr.in/${loc}?format=j1`, text => {
        const json = JSON.parse(text);
        // DEBUG
        // console.info(JSON.stringify(json, null, 2));
        cc = json.current_condition[0];
        forecast = json.weather;
    })

    Component.onCompleted: reload()

    ElapsedTimer {
        id: timer
    }
}
