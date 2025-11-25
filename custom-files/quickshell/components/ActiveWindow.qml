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
        radius: Theme.rounding.pillMedium
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        border {
            width: 2
            color: Qt.alpha(Theme.colors.secondary, 0.3)
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }
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
        anchors.centerIn: parent

        Rectangle {
            id: windowIcon
            implicitHeight: Theme.barIconSize
            implicitWidth: implicitHeight
            radius: Theme.rounding.full
            color: Theme.colors.surface_dim

            scale: ToplevelManager.activeToplevel?.minimized ? 0.85 : 1.0
            opacity: ToplevelManager.activeToplevel?.minimized ? 0.6 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: Theme.anims.duration.small
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.anims.duration.small
                    easing.type: Easing.OutQuad
                }
            }

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

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: Theme.barIconSize
            color: Theme.colors.outline
            radius: Theme.rounding.unsharpen
        }

        Private.StyledText {
            id: windowName
            text: root.windowTitle
            color: Theme.colors.on_surface
            opacity: ToplevelManager.activeToplevel?.minimized ? 0.6 : 1.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.anims.duration.small
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
