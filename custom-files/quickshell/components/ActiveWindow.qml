pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.theme
import qs.utils
import qs.components.internal as Private

Rectangle {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: windowContent.width + Theme.padding
    color: Theme.colors.surface_container
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
        const heuristicLookup = DesktopEntries.heuristicLookup(toplevel.title);
        if (heuristicLookup)
            return Quickshell.iconPath(heuristicLookup.icon);
        // const title = DesktopEntries.byId(toplevel.title);
        // if (title)
        //     return Quickshell.iconPath(title.icon);
        return null;
    }

    RowLayout {
        id: windowContent
        anchors.left: root.left
        anchors.top: root.top
        anchors.topMargin: Theme.margin / 2

        Rectangle {
            id: windowIcon
            implicitHeight: Theme.barHeight - (Theme.margin * 2)
            implicitWidth: implicitHeight
            radius: Theme.rounding.full
            color: Theme.colors.surface_dim

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
                    color: Theme.colors.on_surface_variant
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
            color: Theme.colors.on_surface
        }
    }
}
