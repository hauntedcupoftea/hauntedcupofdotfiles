import QtQuick
import QtQuick.Layouts
import "../theme"
import "../widgets" // Assuming BarButton.qml is in this directory
import "internal" as Private

BarButton {
    id: sessionMenu

    Layout.rightMargin: Theme.padding

    text: "󰐥"
    textColor: "red"
    pressedColor: Theme.colors.red

    Private.SessionMenuPopout {
        // Bind directly to the properties exposed by sessionMenu (the BarButton)
        popupOpen: sessionMenu.isMenuOpen
        powerButton: sessionMenu.button
    }
}
