import QtQuick
import QtQuick.Controls
import Theme 1.0
import "./internal/PowerMenuPopup.qml" as Private

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

    Private.PowerMenuPopup {
        powerButton: powerMenu
        popupOpen: powerMenu.popupOpen
    }
}
