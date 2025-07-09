import Quickshell
import QtQuick
import QtQuick.Controls
import "./theme"

Item {
    id: powerMenu
    property bool popupOpen

    Action {
        id: togglePowerMenu

        onTriggered: {
            powerMenu.popupOpen = !powerMenu.popupOpen;
            // DEBUG: uncomment below
            // print(`popupOpen state: ${powerMenu.popupOpen}`);
        }
    }

    Button {
        id: powerButton
        anchors.fill: parent
        action: togglePowerMenu
        background: Rectangle {
            radius: Theme.rounding.verysmall
            color: Theme.base
        }
        Text {
            anchors.centerIn: parent
            text: ""
            color: Theme.red
            font {
                family: Theme.font.family
                pixelSize: Theme.font.sizeBase
                weight: 700
            }
        }
    }

    PopupWindow {
        anchor {
            item: powerButton
            rect: Qt.rect(powerButton.width, powerButton.height + 8, 0, 0)
            gravity: Edges.Bottom | Edges.Left
        }
        color: "transparent"

        implicitWidth: 500
        implicitHeight: 500
        visible: powerMenu.popupOpen

        Rectangle {
            anchors.fill: parent
            radius: Theme.rounding.verysmall
            color: Theme.surface0
        }
    }
}
