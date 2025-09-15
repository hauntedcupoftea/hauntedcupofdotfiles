import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.theme
import qs.components.internal

Rectangle {
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface_container_high
    border {
        width: 1
        color: Theme.colors.outline_variant
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.margin

        spacing: Theme.padding

        CalendarWidget {
            Layout.fillHeight: true
            Layout.preferredWidth: 400
        }

        WeatherWidget {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
