pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services

Rectangle {
    id: weatherRoot

    implicitWidth: 320
    implicitHeight: 200

    radius: Theme.rounding.small
    color: Theme.colors.surface_container
    border {
        width: 1
        color: Theme.colors.outline_variant
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Theme.padding
        }
        spacing: Theme.margin

        // Header with location and refresh status
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Weather"
                color: Theme.colors.on_surface
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.large
                    weight: Font.Medium
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // Loading indicator
            Rectangle {
                visible: Weather.isLoading
                implicitHeight: Theme.font.normal
                implicitWidth: Theme.font.normal
                radius: Theme.rounding.small
                color: Theme.colors.primary

                SequentialAnimation on opacity {
                    running: Weather.isLoading
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: 0.3
                        to: 1.0
                        duration: 800
                    }
                    NumberAnimation {
                        from: 1.0
                        to: 0.3
                        duration: 800
                    }
                }
            }
        }

        // Main weather display
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.padding

            // Weather icon
            Text {
                id: weatherIcon
                text: Weather.icon
                color: Theme.colors.primary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.huge * 2
                }
                Layout.alignment: Qt.AlignCenter
            }

            // Temperature and description
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: Theme.margin

                Text {
                    text: Weather.temp
                    color: Theme.colors.on_surface
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.huge * 1.5
                        weight: Font.Medium
                    }
                }

                Text {
                    text: Weather.description
                    color: Theme.colors.on_surface_variant
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.normal
                    }
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Text {
                    text: `Feels like ${Weather.feelsLike}`
                    color: Theme.colors.on_surface_variant
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.small
                    }
                }
            }
        }

        // Additional weather info
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.padding

            Text {
                text: ` ${Weather.humidity}%`
                color: Theme.colors.on_surface_variant
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // Location info (if available)
            Text {
                text: Weather.loc ? ` ${Weather.locationName}` : ""
                color: Theme.colors.on_surface_variant
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.smallest
                }
                visible: Weather.loc
            }
        }

        // Forecast preview (if available)
        RowLayout {
            Layout.fillWidth: true
            visible: Weather.forecast?.length > 0
            spacing: Theme.margin

            Repeater {
                model: Math.min(3, Weather.forecast ? Weather.forecast.length : 0)

                Rectangle {
                    id: forecast
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 50
                    radius: Theme.rounding.unsharpenmore
                    color: Theme.colors.surface_variant
                    required property var modelData
                    required property int index

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            text: {
                                if (!Weather.forecast || !Weather.forecast[forecast.index])
                                    return "";
                                const date = new Date(Weather.forecast[forecast.index].date);
                                return date.toLocaleDateString('en', {
                                    weekday: 'short'
                                });
                            }
                            color: Theme.colors.on_surface_variant
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.smaller
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: {
                                if (!Weather.forecast || !Weather.forecast[forecast.index])
                                    return "󰧠";
                                const hourly = Weather.forecast[forecast.index].hourly;
                                if (!hourly || hourly.length === 0)
                                    return "󰧠";
                                const weatherCode = hourly[Math.floor(hourly.length / 2)]?.weatherCode;
                                return Weather.weatherIcons[weatherCode] || "󰧠";
                            }
                            color: Theme.colors.primary
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.normal
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: {
                                if (!Weather.forecast || !Weather.forecast[forecast.index])
                                    return "";
                                return `${Weather.forecast[forecast.index].maxtempC}°`;
                            }
                            color: Theme.colors.on_surface_variant
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.smallest
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    // Click to refresh
    MouseArea {
        anchors.fill: parent
        onClicked: Weather.reload()
        cursorShape: Qt.PointingHandCursor
    }

    // Fallback state when no data is available
    Rectangle {
        anchors.fill: parent
        visible: !Weather.cc && !Weather.isLoading
        color: Theme.colors.surface_container
        radius: parent.radius

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Theme.margin

            Text {
                text: "󰧠"
                color: Theme.colors.on_surface_variant
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.huge
                }
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Weather unavailable"
                color: Theme.colors.on_surface_variant
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                }
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Click to retry"
                color: Theme.colors.primary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                }
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
