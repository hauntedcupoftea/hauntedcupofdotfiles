pragma Singleton
import QtQuick

import qs.config

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
    readonly property int margin: 6
    readonly property int padding: 10
    readonly property int barHeight: 40
    readonly property int barIconSize: 20
    readonly property int trayIconSize: 16
    readonly property int playerWidth: 112
    readonly property int debugOffsetHeight: Settings.debug ? 36 : 0
}
