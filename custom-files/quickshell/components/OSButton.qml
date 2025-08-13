import QtQuick
import QtQuick.Controls
import Quickshell

import qs.widgets
import qs.theme
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: osText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    background: Rectangle {
        id: bg
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.small

        Heartbeat {
            anchors.centerIn: bg
            width: parent.width
            minWidth: osText.height + Theme.margin
            maxWidth: parent.width
            height: root.height - Theme.padding
        }
    }
    Private.StyledText {
        id: osText
        text: ""
        anchors.centerIn: parent
        color: root.hovered ? Theme.colors.secondary : Theme.colors.on_secondary
        animate: false
        weight: 500
        font.pixelSize: Theme.font.large
    }

    action: Action {
        onTriggered: {
            print("im triggered");
            Quickshell.execDetached([Quickshell.env("TERM")]);
        }
    }

    Private.ToolTipPopup {
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(Theme.padding, root.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right
        blockShow: root.menuOpen

        Private.StyledText {
            text: "<3"
            color: Theme.colors.on_surface_variant
        }
    }
}
