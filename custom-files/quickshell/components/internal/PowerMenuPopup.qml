import Quickshell
import QtQuick
import "../../theme"

PopupWindow {
    property var powerButton
    property bool popupOpen
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width, powerButton.height + 8, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }
    color: "transparent"

    implicitWidth: 500
    implicitHeight: 500
    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.surface0
    }
}
