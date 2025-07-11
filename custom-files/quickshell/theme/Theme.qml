pragma Singleton
import QtQuick

QtObject {
    // --- COLORS ---
    readonly property color rosewater: "#F5E0DC"
    readonly property color flamingo: "#F2CDCD"
    readonly property color pink: "#F5C2E7"
    readonly property color mauve: "#CBA6F7"
    readonly property color red: "#F38BA8"
    readonly property color maroon: "#EBA0AC"
    readonly property color peach: "#FAB387"
    readonly property color yellow: "#F9E2AF"
    readonly property color green: "#A6E3A1"
    readonly property color teal: "#94E2D5"
    readonly property color sky: "#89DCEB"
    readonly property color sapphire: "#74C7EC"
    readonly property color blue: "#89B4FA"
    readonly property color lavender: "#B4BEFE"

    readonly property color text: "#CDD6F4"
    readonly property color subtext1: "#BAC2DE"
    readonly property color subtext0: "#A6ADC8"

    readonly property color overlay2: "#9399B2"
    readonly property color overlay1: "#7F849C"
    readonly property color overlay0: "#6C7086"

    readonly property color surface2: "#585B70"
    readonly property color surface1: "#45475A"
    readonly property color surface0: "#313244"

    readonly property color base: "#1E1E2E"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111B"

    // --- TYPOGRAPHY ---
    readonly property ThemeFont font: ThemeFont {}

    // --- LAYOUT ---
    readonly property ThemeRounding rounding: ThemeRounding {}

    readonly property int margin: 8
    readonly property int padding: 10
}
