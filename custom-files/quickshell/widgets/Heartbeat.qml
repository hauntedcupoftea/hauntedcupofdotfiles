import QtQuick
import qs.theme
import qs.services

Rectangle {
    id: root
    radius: Theme.rounding.verysmall

    property real systemActivity: UsageMetrics.systemActivity
    property real minWidth: parent.width * 0.2
    property real maxWidth: parent.width * 0.8
    property int minBpm: 60
    property int maxBpm: 160

    readonly property real currentBpm: root.minBpm + (root.systemActivity * (root.maxBpm - root.minBpm))
    readonly property int cycleDuration: 60000 / root.currentBpm
    readonly property real dubWidth: root.minWidth + (root.maxWidth - root.minWidth) * 0.6

    width: root.minWidth
    implicitHeight: 2
    color: root.systemActivity > 0.7 ? Theme.colors.error : Theme.colors.primary

    SequentialAnimation on width {
        running: true
        loops: Animation.Infinite

        NumberAnimation {
            to: root.maxWidth
            duration: root.cycleDuration * 0.10
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minWidth
            duration: root.cycleDuration * 0.25
            easing.type: Easing.InQuad
        }
        PauseAnimation {
            duration: root.cycleDuration * 0.05
        }

        NumberAnimation {
            to: root.dubWidth
            duration: root.cycleDuration * 0.08
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: root.minWidth
            duration: root.cycleDuration * 0.17
            easing.type: Easing.InQuad
        }
        PauseAnimation {
            duration: root.cycleDuration * 0.35
        }
    }
}
