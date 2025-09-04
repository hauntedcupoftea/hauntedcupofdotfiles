import QtQuick
import qs.widgets
import qs.services
import qs.theme
import "internal" as Private
import qs.sidebar

AbstractBarButton {
    id: root
    implicitWidth: indicator.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - Theme.margin

    MouseArea {
        id: dndToggle
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onPressed: {
            Notify.toggleDND();
        }
    }

    background: Rectangle {
        radius: Theme.rounding.small
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
    }

    Private.StyledText {
        id: indicator
        anchors.centerIn: root
        text: `${Notify.indicatorIcon} ${Notify.items.length}`
        textColor: Theme.colors.tertiary
    }

    sidebarComponent: "notification-manager"
}
