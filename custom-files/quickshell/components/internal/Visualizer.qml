import QtQuick
import Quickshell.Widgets
import qs.services
import qs.theme

Item {
    id: visualizer

    property real progress: 0.5      // From Player.percentageProgress
    property bool isPlaying: false   // From Player.active.isPlaying

    Component.onCompleted: {
        if (isPlaying) {
            Cava.addRef();
        }
    }

    Component.onDestruction: {
        Cava.removeRef();
    }

    onIsPlayingChanged: {
        if (isPlaying) {
            Cava.addRef();
        } else {
            Cava.removeRef();
        }
    }

    ClippingRectangle {
        id: background
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container

        Canvas {
            id: liquidCanvas
            anchors.fill: parent

            property var audioLevels: []
            property real animationTime: 0

            Connections {
                target: Cava
                function onValuesChanged() {
                    if (visualizer.isPlaying) {
                        liquidCanvas.audioLevels = Cava.values;
                        liquidCanvas.requestPaint();
                    }
                }
            }

            Timer {
                running: visualizer.isPlaying
                repeat: true
                interval: 50
                onTriggered: {
                    liquidCanvas.animationTime += 0.1;
                    liquidCanvas.requestPaint();
                }
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var baseLevel = 0.5; // Half-filled like volume indicator
                var waveHeight = height * 0.15; // How much the waves can vary

                var liquidColor;
                if (visualizer.progress < 0.3) {
                    liquidColor = Qt.alpha(Theme.colors.on_surface_variant, 0.6);
                } else if (visualizer.progress < 0.7) {
                    liquidColor = Qt.alpha(Theme.colors.primary, 0.5);
                } else {
                    liquidColor = Qt.alpha(Theme.colors.primary, 0.8);
                }

                ctx.fillStyle = liquidColor;
                ctx.beginPath();

                ctx.moveTo(0, height);
                ctx.lineTo(0, height * baseLevel);

                var points = 20;
                for (var i = 0; i <= points; i++) {
                    var x = (i / points) * width;
                    var baseY = height * baseLevel;

                    var wave = 0;
                    if (visualizer.isPlaying && audioLevels && audioLevels.length > 0) {
                        // Use audio data to create waves
                        var audioIndex = Math.floor((i / points) * audioLevels.length);
                        var audioLevel = audioLevels[audioIndex] || 0;
                        var normalizedAudio = audioLevel / 100.0;

                        // Combine audio data with smooth sine waves
                        var audioWave = Math.sin(i * 0.3) * normalizedAudio * waveHeight;
                        var smoothWave = Math.sin(animationTime + i * 0.2) * waveHeight * 0.3;

                        wave = audioWave + smoothWave;
                    } else if (visualizer.isPlaying) {
                        // Fallback gentle wave when no audio data
                        wave = Math.sin(animationTime + i * 0.2) * waveHeight * 0.4;
                    }

                    var y = baseY - wave;

                    if (i === 0) {
                        ctx.lineTo(x, y);
                    } else {
                        var prevX = ((i - 1) / points) * width;
                        var controlX = (prevX + x) / 2;
                        ctx.quadraticCurveTo(controlX, y, x, y);
                    }
                }

                ctx.lineTo(width, height);
                ctx.lineTo(0, height);
                ctx.closePath();
                ctx.fill();

                if (visualizer.progress > 0) {
                    ctx.fillStyle = Qt.alpha(Theme.colors.primary, 0.2);
                    ctx.fillRect(0, 0, width * visualizer.progress, height);
                }
            }
        }
    }
}
