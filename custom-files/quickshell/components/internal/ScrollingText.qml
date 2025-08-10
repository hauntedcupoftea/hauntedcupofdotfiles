import QtQuick
import Quickshell.Widgets
import qs.theme
import qs.config

ClippingRectangle {
    id: root
    property string scrollingText
    property bool animate

    color: "transparent"

    Text {
        id: movingText
        x: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        text: root.scrollingText
        color: Theme.colors.on_surface
        verticalAlignment: Qt.AlignVCenter

        font {
            family: Theme.font.family
            pixelSize: Theme.font.large
            weight: 600
        }

        NumberAnimation on x {
            running: root.animate
            from: root.width - Theme.padding
            to: -1 * movingText.width
            loops: Animation.Infinite
            duration: {
                var distance = Math.abs(root.width - Theme.padding) + movingText.width;
                return (distance / Settings.pixelsPerSecond) * 1000;
            }
        }
    }
}
