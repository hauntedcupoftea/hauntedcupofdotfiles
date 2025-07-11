import QtQuick
import Quickshell
import QtQuick.Controls
import "../theme"
import "../services"

Button {
    id: clockWidgetRoot
    implicitWidth: clockWidgetText.implicitWidth + (Theme.padding * 2)
    implicitHeight: 32

    background: Rectangle {
        anchors.fill: clockWidgetRoot
        color: Theme.base
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
        color: Theme.peach
        font {
            family: Theme.font.family
            pixelSize: Theme.font.sizeBase
            weight: 700
        }
    }

    ToolTip {
        id: clockWidgetToolTip
        visible: clockWidgetRoot.hovered
        delay: 800
        timeout: 5000
        background: Rectangle {
            color: Theme.surface1
            radius: Theme.rounding.verysmall
        }

        Text {
            text: "Clock. click for calendar"
            color: Theme.text
            font {
                family: Theme.font.family
            }
        }
    }
}
