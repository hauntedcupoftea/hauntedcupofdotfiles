import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: clockWidgetText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)
    Layout.leftMargin: Theme.padding

    background: Rectangle {
        anchors.fill: root
        color: root.hovered ? Theme.colors.surface0 : Theme.colors.crust
        radius: Theme.rounding.verysmall
    }

    Private.StyledText {
        id: clockWidgetText
        text: Time.time
        anchors.centerIn: parent
        color: Theme.colors.peach
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
                text: "📅 Today: " + Time.time
                color: Theme.colors.text
            }
            Private.StyledText {
                text: "🌤️ Weather: 22°C Sunny"
                color: Theme.colors.subtext1
            }
            Private.StyledText {
                text: "Click for calendar"
                color: Theme.colors.subtext0
            }
        }
    }

    Private.ClockWidgetPopout {
        popupOpen: root.menuOpen
        powerButton: root
    }
}
