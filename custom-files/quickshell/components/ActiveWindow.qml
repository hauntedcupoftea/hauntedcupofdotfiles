pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.theme
import qs.widgets
import qs.utils
import qs.components.internal as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - Theme.margin
    implicitWidth: windowContent.width + (Theme.padding * 2)
    background: Rectangle {
        anchors.fill: root
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.verysmall
    }
    sidebarComponent: "to-do"

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
        const title = DesktopEntries.byId(toplevel.title);
        if (title)
            return Quickshell.iconPath(title.icon);
        const heuristicLookup = DesktopEntries.heuristicLookup(toplevel.title);
        if (heuristicLookup)
            return Quickshell.iconPath(heuristicLookup.icon);
        return null;
    }

    RowLayout {
        id: windowContent
        spacing: Theme.padding
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            margins: Theme.margin
        }

        Rectangle {
            id: windowIcon
            implicitHeight: Theme.barIconSize
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
