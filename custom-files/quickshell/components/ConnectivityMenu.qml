import QtQuick
import Quickshell

import qs.theme
import qs.services
import qs.widgets

import "internal" as Private

AbstractBarButton {
    id: connectivityMenu
    implicitWidth: conText.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    Private.StyledText {
        id: conText
        anchors.centerIn: connectivityMenu
        text: `${Network.status}  ${Bluetooth.status}`
        textColor: Theme.colors.primary
    }

    background: Rectangle {
        color: connectivityMenu.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.small
    }

    sidebarComponent: "connectivity-menu"

    Private.ToolTipPopup {
        id: connectivityToolTip
        expandDirection: Edges.Bottom
        targetWidget: connectivityMenu
        triggerTarget: true
        position: Qt.rect(connectivityMenu.width / 2, connectivityMenu.height + Theme.padding, 0, 0)

        Private.StyledText {
            text: "Network and Bluetooth status"
            color: Theme.colors.on_surface_variant
        }
    }
}
