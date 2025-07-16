pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "../theme"
import "internal" as Private

Rectangle {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: windowContent.width + (Theme.padding * 2)
    color: Theme.colors.crust
    radius: Theme.rounding.small

    property bool showDesktop: Hyprland.focusedWorkspace.toplevels.values.length == 0 || ToplevelManager.activeToplevel == null
    property bool showIcon: !root.showDesktop && DesktopEntries.byId(ToplevelManager.activeToplevel.appId)

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
                active: root.showIcon
                anchors.centerIn: parent
                sourceComponent: Image {
                    anchors.centerIn: parent
                    sourceSize: Qt.size(Theme.barIconSize, Theme.barIconSize)
                    source: Quickshell.iconPath(DesktopEntries.byId(ToplevelManager.activeToplevel?.appId)?.icon)
                }
            }

            Loader {
                active: !root.showIcon
                anchors.centerIn: parent
                sourceComponent: Text {
                    text: {
                        const title = root.getWindowTitle();
                        if (title === "Desktop")
                            return "";
                        if (title.contains(".exe") || title.contains("steam")) // steamgamescope apps + .exe
                            return "󰺷";
                        return "";
                    }
                    color: Theme.colors.subtext0
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.barIconSize
                        weight: 400
                    }
                }
            }
        }

        Private.StyledText {
            id: windowName
            text: root.getWindowTitle()
            color: Theme.colors.text
        }
    }
}
