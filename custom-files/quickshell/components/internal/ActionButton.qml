import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../../theme"

Button {
    id: control
    action: buttonAction
    property string buttonIcon: ""
    property string buttonText: "Action"
    property list<string> command: ["notify-send", "The Button You Just Clicked", "please pass a command >.<"]
    property color iconColor: Theme.colors.text

    Action {
        id: buttonAction
        onTriggered: {
            Quickshell.execDetached(control.command);
        }
    }

    background: Rectangle {
        color: control.hovered ? Theme.colors.surface1 : Theme.colors.surface0
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
            text: control.buttonIcon
            color: control.iconColor
            Layout.alignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large * 1.8
            }
        }

        Text {
            text: control.buttonText
            color: Theme.colors.subtext1
            Layout.alignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.normal
            }
        }
    }
}
