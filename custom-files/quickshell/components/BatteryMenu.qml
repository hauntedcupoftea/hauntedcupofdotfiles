import QtQuick
import QtQuick.Layouts
import "../widgets"
import "../services"
import "../theme"
import "internal" as Private

AbstractBarButton {
    id: batteryIndicator
    // implicitWidth: battery.width + (Theme.padding * 2)
    implicitWidth: 100
    implicitHeight: Theme.barHeight - (Theme.margin * 2)
    background: Rectangle {
        id: background
        radius: Theme.rounding.full
        color: Theme.colors.crust
    }
}
