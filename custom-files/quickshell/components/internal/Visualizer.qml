import QtQuick
import Quickshell.Widgets
import qs.services
import qs.config
import qs.theme

Item {
    id: visualizer

    property real progress: 0.5
    property bool isPlaying: false

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
                interval: 1000 / Settings.visualizerFPS
                onTriggered: {
                    liquidCanvas.animationTime += 0.15;
                    liquidCanvas.requestPaint();
                }
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var baseLevel = 0.75;
                var waveHeight = height * 0.75;

                var liquidColor = Qt.alpha(Theme.colors.primary, 0.5);
                ctx.fillStyle = liquidColor;
                ctx.beginPath();

                ctx.moveTo(0, height);
                ctx.lineTo(0, height * baseLevel);

                var points = Settings.visualizerBars;
                for (var i = 0; i <= points; i++) {
                    var x = (i / points) * width;
                    var baseY = height * baseLevel;

                    var wave = 0;
                    if (visualizer.isPlaying && audioLevels && audioLevels.length > 0) {
                        var audioIndex = Math.min(i, audioLevels.length - 1);
                        var audioLevel = audioLevels[audioIndex] || 0;
                        var normalizedAudio = audioLevel / 100.0;
                        wave = normalizedAudio * waveHeight;

                        if (i > 0 && i < points && audioLevels.length > i) {
                            var prevLevel = (audioLevels[i - 1] || 0) / 100.0;
                            var nextLevel = (audioLevels[i + 1] || audioLevels[i]) / 100.0;
                            var smoothing = (prevLevel + normalizedAudio + nextLevel) / 3;
                            wave = smoothing * waveHeight;
                        }
                        var liquidMotion = Math.sin(animationTime * 0.5 + i * 0.2) * waveHeight * 0.1;
                        wave += liquidMotion;
                    } else if (visualizer.isPlaying) {
                        var fakeLevel = Math.abs(Math.sin(animationTime + i * 0.5)) * (0.3 + Math.random() * 0.4);
                        wave = fakeLevel * waveHeight;
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
