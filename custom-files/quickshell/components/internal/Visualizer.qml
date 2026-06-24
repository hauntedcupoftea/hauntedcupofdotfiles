pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.config
import qs.theme

ProgressBar {
    id: visualizer
    value: progress
    active: isPlaying
    enableSmoothing: false
    property real progress: 0.5
    property bool isPlaying: false

    Component.onCompleted: if (isPlaying)
        Cava.addRef()
    Component.onDestruction: Cava.removeRef()
    onIsPlayingChanged: isPlaying ? Cava.addRef() : Cava.removeRef()

    Row {
        id: barContainer
        anchors.fill: parent
        z: 1

        anchors.margins: Theme.margin / 2
        spacing: Theme.margin / 4

        readonly property int barCount: Math.min(Settings.visualizerBars, 8)

        Repeater {
            model: barContainer.barCount

            Item {
                id: pillRoot
                required property int index

                width: (barContainer.width - (barContainer.spacing * (barContainer.barCount - 1))) / barContainer.barCount
                height: barContainer.height

                readonly property real level: {
                    if (!visualizer.active)
                        return 0.0;
                    const rawLevel = Cava.values[index] || 0;
                    return Math.max(0.0, Math.min(rawLevel / 100.0, 1.0));
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.rounding.full
                    color: Qt.alpha(Theme.colors.surface_variant, 0.2)

                    Rectangle {
                        id: barPill
                        width: parent.width
                        radius: parent.radius
                        anchors.centerIn: parent

                        readonly property real minHeight: Theme.margin / 2
                        height: Math.max(minHeight, parent.height * pillRoot.level)

                        color: {
                            if (pillRoot.level > 0.8)
                                return Theme.colors.error;
                            if (pillRoot.level > 0.5)
                                return Theme.colors.tertiary;
                            return Theme.colors.secondary;
                        }

                        Behavior on height {
                            SpringAnimation {
                                spring: 2.5
                                damping: 0.35
                                mass: 0.6
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }
            }
        }
    }
}
