import QtQuick
import qs.theme
import qs.services

Text {
    id: root

    property real systemActivity: UsageMetrics.systemActivity
    text: "❤"

    font.pixelSize: 24

    property real minScale: 1.0
    property real maxScale: 1.3

    property int minBpm: 60
    property int maxBpm: 160

    color: root.systemActivity > 0.7 ? Theme.colors.error : (Theme.colors.secondary)

    readonly property real currentBpm: root.minBpm + (root.systemActivity * (root.maxBpm - root.minBpm))
    readonly property int cycleDuration: 60000 / root.currentBpm
    readonly property real dubScale: root.minScale + (root.maxScale - root.minScale) * 0.6

    SequentialAnimation on scale {
        running: true
        loops: Animation.Infinite

        NumberAnimation {
            to: root.maxScale
            duration: root.cycleDuration * 0.10
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minScale
            duration: root.cycleDuration * 0.25
            easing.type: Easing.InQuad
        }
        PauseAnimation {
            duration: root.cycleDuration * 0.05
        }

        NumberAnimation {
            to: root.dubScale
            duration: root.cycleDuration * 0.08
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minScale
            duration: root.cycleDuration * 0.17
            easing.type: Easing.InQuad
        }
        PauseAnimation {
            duration: root.cycleDuration * 0.35
        }
    }
}
