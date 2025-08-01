import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets
import "internal" as Private

BarButton {
    id: sessionMenu

    Layout.rightMargin: Theme.padding

    text: "󰐥"
    textColor: Theme.colors.error_container
    pressedColor: Theme.colors.error

    Private.SessionMenuPopout {
        popupOpen: sessionMenu.isMenuOpen
        powerButton: sessionMenu.button
    }
}
