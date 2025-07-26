import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

import qs.theme

Button {
    id: control
    action: buttonAction
    property string buttonIcon: ""
    property string buttonText: "Action"
    property list<string> command: ["notify-send", "The Button You Just Clicked", "please pass a command >.<"]
    property color iconColor: Theme.colors.on_surface

    implicitHeight: Theme.font.huge * 1.8 + (Theme.padding * 2.2)
    implicitWidth: actionIcon.width + (Theme.font.large * 2.2)

    Action {
        id: buttonAction
        onTriggered: {
            Quickshell.execDetached(control.command);
        }
    }

    background: Rectangle {
        color: control.hovered ? Theme.colors.surface_container : Theme.colors.surface
        radius: Theme.rounding.small

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    contentItem: ColumnLayout {
        scale: control.pressed ? 0.9 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }

        Text {
            id: actionIcon
            text: control.buttonIcon
            color: control.iconColor
            Layout.alignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.huge * 1.8
            }
        }
    }
}
