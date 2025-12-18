pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets
import qs.services
import qs.config
import qs.theme

Item {
    id: visualizer

    property real progress: 0.5
    property bool isPlaying: false

    // Resource management
    Component.onCompleted: if (isPlaying)
        Cava.addRef()
    Component.onDestruction: Cava.removeRef()
    onIsPlayingChanged: isPlaying ? Cava.addRef() : Cava.removeRef()

    ClippingRectangle {
        id: background
        anchors.fill: parent
        border {
            width: 1
            color: Qt.alpha(Theme.colors.outline_variant, 0.4)
        }
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container

        // Progress indicator - gradient overlay with subtle pulse
        Rectangle {
            id: progressBar
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * visualizer.progress
            radius: Theme.rounding.verysmall
            visible: visualizer.progress > 0

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0.0
                    color: Qt.alpha(Theme.colors.primary, 0.25)
                }
                GradientStop {
                    position: 0.7
                    color: Qt.alpha(Theme.colors.primary, 0.15)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.alpha(Theme.colors.primary, 0.05)
                }
            }

            // Subtle animated shine effect when playing
            Rectangle {
                id: shine
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                width: Theme.padding * 3
                visible: visualizer.isPlaying && visualizer.progress > 0.05

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0.5
                        color: Qt.alpha(Theme.colors.primary, 0.3)
                    }
                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }

                opacity: 0.6
                SequentialAnimation on opacity {
                    running: shine.visible
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: 1.0
                        duration: 1200
                        easing.type: Easing.InOutCubic
                    }
                    NumberAnimation {
                        to: 0.6
                        duration: 1200
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Behavior on width {
                NumberAnimation {
                    duration: Theme.anims.duration.normal
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Bar container
        Row {
            id: barContainer
            anchors.fill: parent
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

                    // Get audio level, clamp to valid range
                    readonly property real level: {
                        if (!visualizer.isPlaying)
                            return 0.0;
                        const rawLevel = Cava.values[index] || 0;
                        return Math.max(0.0, Math.min(rawLevel / 100.0, 1.0));
                    }

                    // Background slot - slightly more visible for better visual feedback
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.rounding.full
                        color: Qt.alpha(Theme.colors.surface_variant, 0.3)

                        // Active bar - grows from center baseline
                        Rectangle {
                            id: barPill
                            width: parent.width
                            radius: parent.radius
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }

                            // Minimum height ensures visibility even at low levels
                            readonly property real minHeight: Theme.margin / 2
                            height: Math.max(minHeight, parent.height * pillRoot.level)

                            // Color based on intensity
                            color: {
                                if (pillRoot.level > 0.8)
                                    return Theme.colors.error;
                                if (pillRoot.level > 0.5)
                                    return Theme.colors.tertiary;
                                return Theme.colors.secondary;
                            }

                            // Smooth spring animation for natural feel
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
}
