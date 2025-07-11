import QtQuick
import QtQuick.Controls
import "../theme"
import "internal" as Private

Item {
    id: powerMenu
    property bool popupOpen
    implicitWidth: 64
    implicitHeight: 28

    Action {
        id: togglePowerMenu

        onTriggered: {
            powerMenu.popupOpen = !powerMenu.popupOpen;
            // DEBUG: uncomment below
            // console.info(`popupOpen state: ${powerMenu.popupOpen}`);
        }
    }

    Button {
        id: powerButton
        anchors.fill: parent
        action: togglePowerMenu

        background: Rectangle {
            radius: Theme.rounding.verysmall
            color: powerButton.hovered ? Theme.colors.surface0 : Theme.colors.crust
            states: State {
                name: "pressed"
                when: powerButton.pressed || powerMenu.popupOpen
                PropertyChanges {
                    powerButtonText.color: Theme.colors.red
                }
            }
        }

        Text {
            id: powerButtonText
            anchors.centerIn: parent
            text: "󰤟  󰂯" // CHANGE TO DYNAMIC TEXT FOR POP UP PANEL
            color: "red"
            font {
                family: Theme.font.family
                pointSize: Theme.font.sizeBase
                weight: 700
            }
        }
    }

    Private.PowerMenuPopup {
        powerButton: powerMenu
        popupOpen: powerMenu.popupOpen
    }
}
