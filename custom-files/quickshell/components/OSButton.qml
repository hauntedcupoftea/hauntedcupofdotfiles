import QtQuick
import QtQuick.Controls
import Quickshell

import qs.theme
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: osText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    background: Rectangle {
        anchors.fill: root
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.small
    }

    Private.StyledText {
        id: osText
        text: ""
        anchors.centerIn: parent
        color: Theme.colors.secondary
        animate: false
        weight: 500
        font.pixelSize: Theme.font.large
    }

    action: Action {
        onTriggered: {
            Quickshell.execDetached(["echo", "$TERM"]);
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
