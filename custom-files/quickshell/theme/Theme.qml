pragma Singleton
import QtQuick

QtObject {
    // --- ANIMATION SETTINGS ---
    readonly property ThemeAnimations anims: ThemeAnimations {}

    // --- COLORS ---
    readonly property ThemeColors colors: ThemeColors {}

    // --- TYPOGRAPHY ---
    readonly property ThemeFont font: ThemeFont {}

    // --- LAYOUT ---
    readonly property ThemeRounding rounding: ThemeRounding {}

    // we will add more variables here one day bro i swear bro pl-
    readonly property int margin: 8
    readonly property int padding: 10
}
