import QtQuick
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

    // Custom popup tooltip
    Private.ClockTooltipPopup {
        targetWidget: clockWidgetRoot
        shouldShow: clockWidgetRoot.hovered
        showDelay: 800
        hideDelay: 200
    }
}
