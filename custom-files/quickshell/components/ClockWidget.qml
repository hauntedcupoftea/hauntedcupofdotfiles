import QtQuick
// import Quickshell
import QtQuick.Controls
import "../theme"
import "../services"

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

    ToolTip {
        id: clockWidgetToolTip
        visible: clockWidgetRoot.hovered
        delay: 800
        timeout: 5000
        background: Rectangle {
            color: Theme.colors.surface1
            radius: Theme.rounding.verysmall
        }

        Text {
            text: "Clock. click for calendar"
            color: Theme.colors.text
            font {
                family: Theme.font.family
            }
        }
    }
}
