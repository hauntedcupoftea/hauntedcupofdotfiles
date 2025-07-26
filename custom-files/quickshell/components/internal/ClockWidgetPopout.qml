import Quickshell
import QtQuick
import QtQuick.Controls

import qs.theme

// import "../../services"

// here we will implement some sort of calendar display + a pomodoro timer.
PopupWindow {
    id: root
    property var powerButton
    property bool popupOpen
    anchor {
        item: powerButton
        rect: Qt.rect(0, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Right
    }
    color: "transparent"

    implicitWidth: 512
    implicitHeight: 900
    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.background
        border {
            width: 1
            color: Theme.colors.outline
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onExited: {
                root.powerButton.action.trigger();
            }
            MonthGrid {
                id: textSample
                anchors.fill: parent
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                    weight: 800
                }
            }
        }
    }
}
