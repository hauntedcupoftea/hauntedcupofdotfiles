import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "../../theme"

Button {
    id: control
    property string icon: ""
    property string text: "Action"
    property Action command
    property color iconColor: Theme.text

    implicitWidth: 32
    implicitHeight: 32

    background: Rectangle {
        color: control.hovered ? Theme.surface1 : Theme.surface0
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
            text: control.icon
            color: control.iconColor
            Layout.alignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.sizeLarge * 1.8
            }
        }

        Text {
            text: control.text
            color: Theme.subtext1
            Layout.alignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.sizeBase
            }
        }
    }
}
