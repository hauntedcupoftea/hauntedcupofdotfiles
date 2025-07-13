import QtQuick
import "../widgets"
import "../services"
import "../theme"
import "internal" as Private

AbstractBarButton {
    id: batteryIndicator
    implicitWidth: battery.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin * 2)
    background: Rectangle {}

    Private.StyledText {
        id: battery
        text: `${Battery.percentage.toFixed(2) * 100}`
    }
}
