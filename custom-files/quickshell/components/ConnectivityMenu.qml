import QtQuick
import Quickshell
import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

BarButton {
    id: connectivityMenu

    text: `${Network.status}  ${Bluetooth.status}`
    textColor: Theme.colors.secondary
    pressedColor: Theme.colors.primary

    Private.ConnectivityMenuPopout {
        popupOpen: connectivityMenu.isMenuOpen
        powerButton: connectivityMenu.button
    }

    Private.ToolTipPopup {
        id: connectivityToolTip
        expandDirection: Edges.Bottom
        targetWidget: connectivityMenu.button
        triggerTarget: true
        position: Qt.rect(connectivityMenu.width / 2, connectivityMenu.height + Theme.padding, 0, 0)
        blockShow: connectivityMenu.isMenuOpen

        Private.StyledText {
            text: "Network and Bluetooth status"
            color: Theme.colors.on_surface_variant
        }
    }
}
