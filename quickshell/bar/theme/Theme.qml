pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: theme

    property string themeFilePath: Quickshell.env("HOME") + "/.config/wallust/theme.json"

    property color color0: "#00000000"
    property color color1: "#00000000"
    property color color2: "#00000000"
    property color color3: "#00000000"
    property color color4: "#00000000"
    property color color5: "#00000000"
    property color color6: "#00000000"
    property color color7: "#00000000"
    property color color8: "#00000000"
    property color color9: "#00000000"
    property color color10: "#00000000"
    property color color11: "#00000000"
    property color color12: "#00000000"
    property color color13: "#00000000"
    property color color14: "#00000000"
    property color color15: "#00000000"

    readonly property var colors: [color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12, color13, color14, color15]

    property bool loaded: false
    property var rawColors: ({})

    FileView {
        id: themeFile
        path: "file://" + theme.themeFilePath
        watchChanges: true

        onFileChanged: reload()

        onLoaded: {
            try {
                const data = JSON.parse(text())

                for (let i = 0; i < 16; i++) {
                    const key = "color" + i
                    if (data[key] !== undefined) {
                        theme[key] = data[key]
                    }
                }

                theme.rawColors = data
                const wasLoaded = theme.loaded
                theme.loaded = true
                print(`[Theme] ${wasLoaded ? 'reloaded' : 'loaded'} ${theme.themeFilePath}`);
            } catch (e) {
                console.warn(`[Theme] failed to parse ${theme.themeFilePath}:`, e)
            }
        }
    }

    onThemeFilePathChanged: themeFile.reload()
}
