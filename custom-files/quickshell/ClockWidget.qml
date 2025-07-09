import QtQuick
import "./theme"

Rectangle {
    id: root

    // --- Styling from the Theme Singleton ---
    // Use the 'base' color for the widget's background.
    color: Theme.base

    // Use the universal corner radius from the theme.
    radius: Theme.rounding.verysmall

    // Make the widget's size dynamic. It will be the size of the text
    // plus padding on all sides. This ensures it always fits the content.
    width: clockText.implicitWidth + (Theme.padding * 2)
    height: 32

    // The Text element to display the time, centered within the background.
    Text {
        id: clockText
        text: Time.time
        anchors.centerIn: parent
        color: Theme.text
        font {
            family: Theme.font.family
            pixelSize: Theme.font.sizeBase
            weight: 700
        }
    }
}
