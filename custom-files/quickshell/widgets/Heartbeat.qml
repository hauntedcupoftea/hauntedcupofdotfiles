import QtQuick
import qs.theme

Rectangle {
    id: root

    property real systemActivity: 0.0
    property real minOpacity: 0.45
    property real maxOpacity: 0.8
    property int minBpm: 60
    property int maxBpm: 160
    property bool hovered: false

    readonly property real currentBpm: root.minBpm + (root.systemActivity * (root.maxBpm - root.minBpm))
    readonly property int cycleDuration: 60000 / root.currentBpm
    readonly property real dubOpacity: root.minOpacity + (root.maxOpacity - root.minOpacity) * 0.6

    color: root.hovered ? Theme.colors.surface_container_highest : (root.systemActivity > 0.7 ? Theme.colors.error : Theme.colors.secondary)
    opacity: root.minOpacity

    SequentialAnimation on opacity {
        running: true
        loops: Animation.Infinite

        NumberAnimation {
            to: root.maxOpacity
            duration: root.cycleDuration * 0.10
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minOpacity
            duration: root.cycleDuration * 0.25
            easing.type: Easing.InQuad
        }

        PauseAnimation {
            duration: root.cycleDuration * 0.05
        }

        NumberAnimation {
            to: root.dubOpacity
            duration: root.cycleDuration * 0.08
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minOpacity
            duration: root.cycleDuration * 0.17
            easing.type: Easing.InQuad
        }

        PauseAnimation {
            duration: root.cycleDuration * 0.35
        }
    }
}
