import Quickshell
import QtQuick

import qs.theme
import qs.services

PopupWindow {
    id: root
    property var powerButton
    property bool popupOpen
    property string networkText: JSON.stringify(Network.availableNetworks, null, 2)
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width / 2, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom // qmllint disable
    }
    color: "transparent"

    implicitWidth: 300
    implicitHeight: 240
    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container_high
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
            Text {
                id: textSample
                anchors.fill: parent
                text: root.networkText
                color: Theme.colors.primary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.normal
                    weight: 800
                }
            }
        }
    }
}
