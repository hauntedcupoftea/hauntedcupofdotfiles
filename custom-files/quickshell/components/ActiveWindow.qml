import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import "../theme"
import "internal" as Private

Rectangle {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: windowContent.width + (Theme.padding * 2)
    color: Theme.colors.crust
    radius: Theme.rounding.small

    property bool showDesktop: Hyprland.focusedWorkspace.toplevels.values.length == 0 || ToplevelManager.activeToplevel == null

    function createTitleString(s: string): string {
        return s.slice(0, 1).toUpperCase() + s.slice(1);
    }

    function getWindowTitle() {
        if (showDesktop)
            return "Desktop";
        return root.createTitleString(ToplevelManager.activeToplevel.appId);
    }

    RowLayout {
        id: windowContent
        anchors.centerIn: root

        Rectangle {
            id: windowIcon
            implicitHeight: Theme.barHeight - (Theme.margin * 2)
            implicitWidth: implicitHeight
            radius: Theme.rounding.full
            color: Theme.colors.surface0

            Loader {
                active: !root.showDesktop
                anchors.centerIn: parent
                sourceComponent: IconImage {
                    anchors.centerIn: parent
                    // sourceSize: Qt.size(Theme.barIconSize, Theme.barIconSize)
                    implicitSize: Theme.barIconSize
                    source: Quickshell.iconPath(DesktopEntries.byId(ToplevelManager.activeToplevel.appId).icon)
                    Component.onCompleted: print(Quickshell.iconPath(DesktopEntries.byId(ToplevelManager.activeToplevel.appId).icon))
                }
            }
        }

        Private.StyledText {
            id: windowName
            text: root.getWindowTitle() //title.split('—')[0]
            color: Theme.colors.text
        }
    }
}
