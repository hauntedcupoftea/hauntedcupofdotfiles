import Quickshell
import QtQuick

import qs.theme
import qs.services

PopupWindow {
    id: root
    property string networkText: JSON.stringify(Network.availableNetworks, null, 2)
    anchor {
        gravity: Edges.Bottom // qmllint disable
    }
    color: "transparent"

    implicitWidth: 300
    implicitHeight: 240

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container_high
        border {
            width: 1
            color: Theme.colors.outline
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
