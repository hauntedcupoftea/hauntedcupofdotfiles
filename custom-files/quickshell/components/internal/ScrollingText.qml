import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import "../../theme"

ClippingRectangle {
    id: root
    anchors.fill: parent
    property string scrollingText
    radius: Theme.rounding.small
    anchors.margins: Theme.margin
    color: "transparent"

    Text {
        id: movingText
        x: parent.width
        text: root.scrollingText
        color: Theme.colors.text

        font {
            family: Theme.font.altFamily
            pixelSize: Theme.font.normal
        }

        NumberAnimation on x {
            from: root.width
            to: -1 * movingText.width
            loops: Animation.Infinite
            duration: 8000
        }
    }
}
