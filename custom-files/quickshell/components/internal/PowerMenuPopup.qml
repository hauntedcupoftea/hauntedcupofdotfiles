import Quickshell
import QtQuick
import "../../theme"
import "../../services"

PopupWindow {
    property var powerButton
    property bool popupOpen
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom | Edges.Left
    }
    color: "transparent"

    implicitWidth: 512
    implicitHeight: textSample.height + Theme.padding * 2
    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface0
        Text {
            id: textSample
            anchors.fill: parent
            text: JSON.stringify(Network.availableNetworks, null, 2)
            color: Theme.colors.flamingo
            font {
                family: Theme.font.family
                pointSize: Theme.font.sizeBase
                weight: 800
            }
        }
    }
}
