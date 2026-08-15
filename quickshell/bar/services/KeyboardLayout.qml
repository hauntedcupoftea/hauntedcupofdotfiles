pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    id: root

    property string currentLayout: ""
    property bool isNonLatin: false
    property string displayText: "EN"

    signal layoutChanged

    readonly property var layoutMap: ({
            "mozc": "JA",
            "japanese": "JA",
            "anthy": "JA",
            "korean": "KO",
            "hangul": "KO",
            "chinese": "ZH",
            "pinyin": "ZH",
            "wubi": "ZH",
            "rime": "ZH",
            "keyboard-us": "EN",
            "keyboard-gb": "EN",
            "keyboard-de": "DE",
            "keyboard-fr": "FR",
            "keyboard-es": "ES",
            "keyboard-it": "IT",
            "keyboard-ru": "RU",
            "keyboard-ar": "AR",
            "keyboard-pt": "PT",
            "keyboard-nl": "NL",
            "keyboard-pl": "PL",
            "keyboard-tr": "TR",
            "keyboard-vi": "VI",
            "keyboard-th": "TH"
        })

    readonly property var nonLatinLanguages: ["JA", "KO", "ZH", "AR", "RU", "TH"]

    function getLanguageCode(layout) {
        const normalized = layout.toLowerCase();

        // Check each key in the map
        for (const key in layoutMap) {
            if (normalized.includes(key)) {
                return layoutMap[key];
            }
        }

        // Default to EN for unknown layouts
        return "EN";
    }

    function updateDisplayText() {
        const code = getLanguageCode(currentLayout);
        displayText = code;
        isNonLatin = nonLatinLanguages.includes(code);
    }

    function toggle() {
        fcitxToggle.running = true;
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: fcitxStatus.running = true
    }

    Process {
        id: fcitxStatus
        command: ["fcitx5-remote", "-n"]
        stdout: SplitParser {
            onRead: data => {
                const newLayout = data.trim();
                if (root.currentLayout !== newLayout) {
                    root.currentLayout = newLayout;
                    root.updateDisplayText();
                    root.layoutChanged();
                }
            }
        }
    }

    Process {
        id: fcitxToggle
        command: ["fcitx5-remote", "-t"]
    }
}
