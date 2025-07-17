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
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        text: root.scrollingText
        color: Theme.colors.text
        verticalAlignment: Qt.AlignVCenter
        font {
            family: Theme.font.family
            pixelSize: Theme.font.large
            weight: 600
        }

        NumberAnimation on x {
            from: root.width - Theme.padding
            to: -1 * movingText.width
            loops: Animation.Infinite
            duration: 7500
        }
    }
}
