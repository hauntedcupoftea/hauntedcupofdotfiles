pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme

PopupWindow {
    id: root
    property var powerButton
    property bool popupOpen

    anchor {
        item: powerButton
        rect: Qt.rect(Theme.padding / 4, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Right
    }

    color: "transparent"
    implicitWidth: 400
    implicitHeight: 600
    visible: popupOpen

    HyprlandFocusGrab {
        active: root.visible
        windows: [root]
        onCleared: {
            root.powerButton.action.trigger();
        }
    }

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
