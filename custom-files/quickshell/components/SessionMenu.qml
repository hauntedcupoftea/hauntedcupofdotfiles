import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets
import "internal" as Private

BarButton {
    id: sessionMenu

    Layout.rightMargin: Theme.padding

    text: "󰐥"
    textColor: "red"
    pressedColor: Theme.colors.red

    Private.SessionMenuPopout {
        popupOpen: sessionMenu.isMenuOpen
        powerButton: sessionMenu.button
    }
}
