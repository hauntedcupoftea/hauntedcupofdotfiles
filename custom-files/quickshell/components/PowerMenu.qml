import QtQuick
import QtQuick.Layouts
import "../theme"
import "../widgets" // Assuming BarButton.qml is in this directory
import "internal" as Private

BarButton {
    id: powerMenu

    Layout.rightMargin: Theme.padding

    text: "󰐥"
    textColor: "red"
    pressedColor: Theme.colors.red

    Private.PowerMenuPopout {
        // Bind directly to the properties exposed by powerMenu (the BarButton)
        popupOpen: powerMenu.isMenuOpen
        powerButton: powerMenu.button
    }
}
