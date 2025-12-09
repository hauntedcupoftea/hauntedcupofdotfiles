import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitWidth: windowContent.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - Theme.margin

    background: Rectangle {
        anchors.fill: root
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.pillMedium
        border {
            width: 2
            color: Qt.alpha(Theme.colors.primary, 0.3)
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }
    }

    RowLayout {
        id: windowContent
        spacing: Theme.padding
        anchors.centerIn: parent
        Private.StyledText {
            id: clockWidgetDate
            text: Time.date
            color: Theme.colors.primary
            animate: false
            weight: 500
        }
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: Theme.barIconSize
            color: Theme.colors.outline
            radius: Theme.rounding.unsharpen
            opacity: 0.6
        }
        Private.StyledText {
            id: clockWidgetTime
            text: Time.time
            color: Theme.colors.primary
            animate: false
            weight: 500
            font.pixelSize: Theme.font.normal
        }
    }

    Private.ToolTipPopup {
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(Theme.padding, root.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right

        Column {
            spacing: Theme.margin / 2

            Private.StyledText {
                text: Time.currentDate
                color: Theme.colors.on_surface
                font.pixelSize: Theme.font.normal
            }

            Private.StyledText {
                text: `${Weather.icon} ${Weather.temp} (${Weather.feelsLike}) ${Weather.description}`
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.small
            }

            Private.StyledText {
                text: "Click for calendar"
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.small
                opacity: 0.7
            }
        }
    }

    sidebarComponent: "calendar"
}
