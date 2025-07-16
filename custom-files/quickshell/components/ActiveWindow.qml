pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "../theme"
import "../utils"
import "internal" as Private

Rectangle {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: windowContent.width + (Theme.padding * 2)
    color: Theme.colors.crust
    radius: Theme.rounding.small

    WindowUtils {
        id: utils
    }

    property bool showDesktop: Hyprland.focusedWorkspace?.toplevels.values.length == 0 || ToplevelManager.activeToplevel == null
    property bool showIcon: !root.showDesktop && (DesktopEntries.byId(ToplevelManager.activeToplevel?.appId) || DesktopEntries.byId(ToplevelManager.activeToplevel?.title))

    readonly property string windowTitle: utils.getWindowTitle(ToplevelManager.activeToplevel, showDesktop)
    readonly property string iconText: utils.getIconText(ToplevelManager.activeToplevel, windowTitle)

    function getIcon() {
        if (!ToplevelManager.activeToplevel)
            return null;
        const toplevel = ToplevelManager.activeToplevel;
        if (DesktopEntries.byId(toplevel.appId))
            return Quickshell.iconPath(DesktopEntries.byId(toplevel.appId).icon);
        if (DesktopEntries.byId(toplevel.title))
            return Quickshell.iconPath(DesktopEntries.byId(toplevel.title).icon);
        return null;
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
                    source: root.getIcon()
                }
            }

            Loader {
                active: !root.showIcon
                anchors.centerIn: parent
                sourceComponent: Text {
                    text: root.iconText
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
            text: root.windowTitle
            color: Theme.colors.text
        }
    }
}
