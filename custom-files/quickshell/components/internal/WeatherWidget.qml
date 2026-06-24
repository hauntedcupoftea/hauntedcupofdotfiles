pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services

Rectangle {
    id: weatherRoot

    implicitWidth: 320
    implicitHeight: 200

    radius: Theme.rounding.normal
    color: Theme.colors.surface_container
    clip: true

    border {
        width: 1
        color: Qt.alpha(Theme.colors.outline_variant, 0.5)
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        opacity: 0.15

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: Weather.conditionColor
                Behavior on color {
                    ColorAnimation {
                        duration: 1000
                    }
                }
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            spacing: Theme.margin / 2

            Text {
                text: " " + (Weather.locationName || "Locating...")
                color: Theme.colors.on_surface_variant
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                    weight: Font.Medium
                }
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Rectangle {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                radius: 12
                color: hoverHandler.hovered ? Qt.alpha(Theme.colors.on_surface, 0.1) : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: ""
                    color: Theme.colors.on_surface_variant
                    font.family: Theme.font.family

                    RotationAnimation on rotation {
                        running: Weather.isLoading
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 1000
                    }
                }

                HoverHandler {
                    id: hoverHandler
                }
                TapHandler {
                    onTapped: Weather.fetchWeather()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.padding

            ColumnLayout {
                spacing: 0

                Text {
                    text: Weather.icon
                    color: Weather.conditionColor
                    font {
                        family: Theme.font.family
                        pixelSize: 48
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 500
                        }
                    }
                }

                Text {
                    text: Weather.description
                    color: Theme.colors.on_surface_variant
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.small
                    }
                    Layout.maximumWidth: 120
                    elide: Text.ElideRight
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                text: Weather.temp + "°"
                color: Theme.colors.on_surface
                font {
                    family: Theme.font.family
                    pixelSize: 56
                    weight: Font.Light
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Qt.alpha(Theme.colors.outline, 0.2)
            Layout.bottomMargin: Theme.margin
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.margin

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                RowLayout {
                    spacing: 6
                    Text {
                        text: ""
                        color: Theme.colors.primary
                        font.family: Theme.font.family
                    }
                    Text {
                        text: "Humidity: " + Weather.humidity + "%"
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.small
                    }
                }

                RowLayout {
                    spacing: 6
                    Text {
                        text: ""
                        color: Theme.colors.primary
                        font.family: Theme.font.family
                    }
                    Text {
                        text: "Feels Like: " + Weather.feelsLike + "°"
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.small
                    }
                }
            }

            Repeater {
                model: Math.min(3, Weather.forecast ? Weather.forecast.length : 0)

                Rectangle {
                    id: block
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 50
                    radius: Theme.rounding.small
                    color: Qt.alpha(Theme.colors.surface_variant, 0.3)
                    required property int index

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 0

                        Text {
                            text: {
                                const d = new Date(Weather.forecast[block.index].date);
                                return Qt.formatDate(d, "dd/MMM");
                            }
                            font.pixelSize: 10
                            color: Theme.colors.on_surface_variant
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: {
                                const h = Weather.forecast[block.index].hourly;
                                const code = h[4]?.weatherCode || "113"; // Noon-ish
                                return Weather.weatherIcons[code] || "󰧠";
                            }
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.normal
                            color: Theme.colors.on_surface
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: Weather.forecast[block.index].maxtempC + "°"
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            color: Theme.colors.on_surface
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
