import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "../theme"
import "../services"
import "internal" as Private

Button {
    id: clockWidgetRoot
    implicitWidth: clockWidgetText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin * 2)
    Layout.leftMargin: Theme.padding

    background: Rectangle {
        anchors.fill: clockWidgetRoot
        color: clockWidgetRoot.hovered ? Theme.colors.surface0 : Theme.colors.crust
        radius: Theme.rounding.verysmall
    }

    Action {
        id: clockWidgetAction
        onTriggered: {
            console.warn(`Action Not Implemented on clockWidget`);
        }
    }
    action: clockWidgetAction

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
        targetWidget: clockWidgetRoot
        triggerTarget: true
        position: Qt.rect(Theme.padding, clockWidgetRoot.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right

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
}
