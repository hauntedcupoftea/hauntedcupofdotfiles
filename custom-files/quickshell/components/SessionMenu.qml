import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: sessionMenu

    Layout.rightMargin: Theme.padding

    Private.StyledText {
        text: "󰐥"
        textColor: Theme.colors.error_container
    }

    sidebarComponent: Private.SessionMenuPopout {}
}
