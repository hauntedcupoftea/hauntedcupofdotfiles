pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.components.internal

Rectangle {
    id: root
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface_container_high
    border {
        width: 1
        color: Theme.colors.outline_variant
    }

    readonly property bool useVerticalLayout: width < 800
    readonly property int maxCalendarWidth: 400
    readonly property bool horizontal: true

    Loader {
        anchors.fill: parent
        anchors.margins: Theme.margin

        sourceComponent: root.useVerticalLayout ? verticalLayout : horizontalLayout
    }

    Component {
        id: horizontalLayout

        RowLayout {
            spacing: Theme.padding

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.min(root.maxCalendarWidth, parent.width * 0.55)
                Layout.maximumWidth: root.maxCalendarWidth

                CalendarWidget {
                    anchors.fill: parent
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 280

                WeatherWidget {
                    anchors.fill: parent
                }
            }
        }
    }

    Component {
        id: verticalLayout

        ColumnLayout {
            spacing: Theme.padding

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Layout.minimumHeight: 180

                WeatherWidget {
                    anchors.fill: parent
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 380

                CalendarWidget {
                    anchors.fill: parent
                }
            }
        }
    }
}
