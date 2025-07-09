import Quickshell
import QtQuick
import QtQuick.Controls
import "./theme"

Item {
    id: powerMenu
    property bool popupOpen

    Action {
        id: togglePowerMenu
        text: "Toggle Power Menu"
        icon.name: "power"
        onTriggered: powerMenu.popupOpen = !powerMenu.popupOpen
    }

    Button {
        anchors.fill: parent
        action: togglePowerMenu
        background: Rectangle {
            radius: Theme.rounding.verysmall
            color: Theme.base
        }
    }

    PopupWindow {
        color: Theme.base
        implicitWidth: 500
        implicitHeight: 500
        visible: powerMenu.popupOpen
    }
}
