import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.theme

PopupWindow {
    id: root
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container_high
        border {
            width: 1
            color: Theme.colors.outline_variant
        }

        ScrollView {
            anchors.fill: parent
            anchors.margins: Theme.padding

            ColumnLayout {
                width: parent.width
                spacing: 16

                // WeatherWidget {
                //     Layout.fillWidth: true
                //     Layout.preferredHeight: 200
                // }

                CalendarWidget {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 400
                }
            }
        }
    }
}
// }
