import QtQuick
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: clockWidgetText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    background: Rectangle {
        anchors.fill: root
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.verysmall
    }

    Private.StyledText {
        id: clockWidgetText
        text: Time.time
        anchors.centerIn: parent
        color: Theme.colors.primary
        animate: false
        weight: 500
        font.pixelSize: Theme.font.large
    }

    Private.ToolTipPopup {
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(Theme.padding, root.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right
        blockShow: root.menuOpen

        Column {
            spacing: Theme.margin / 2
            Private.StyledText {
                text: Time.currentDate
                color: Theme.colors.on_surface
            }
            Private.StyledText {
                text: `${Weather.icon} ${Weather.temp} (${Weather.feelsLike}) ${Weather.description}`
                color: Theme.colors.on_surface_variant
            }
            Private.StyledText {
                text: "Click for calendar"
                color: Theme.colors.on_surface_variant
            }
        }
    }

    Private.ClockWidgetPopout {
        popupOpen: root.menuOpen
        powerButton: root
    }
}
