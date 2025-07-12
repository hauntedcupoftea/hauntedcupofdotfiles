import QtQuick
import Quickshell
import QtQuick.Controls
import "../theme"
import "../services"
import "internal" as Private

Button {
    id: clockWidgetRoot
    implicitWidth: clockWidgetText.implicitWidth + (Theme.padding * 2)
    implicitHeight: 28

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

    Text {
        id: clockWidgetText
        text: Time.time
        anchors.centerIn: parent
        color: Theme.colors.peach
        font {
            family: Theme.font.family
            pointSize: Theme.font.sizeBase
            weight: 700
        }
    }

    Private.ToolTipPopup {
        targetWidget: clockWidgetRoot
        position: Qt.rect(Theme.padding, clockWidgetRoot.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right

        Column {
            spacing: Theme.margin / 2
            Text {
                text: "📅 Today: " + Time.time
                color: Theme.colors.text
                font.family: Theme.font.family
            }
            Text {
                text: "🌤️ Weather: 22°C Sunny"
                color: Theme.colors.subtext1
                font.family: Theme.font.family
            }
            Text {
                text: "Click for calendar"
                color: Theme.colors.subtext0
                font.family: Theme.font.family
            }
        }
    }
}
