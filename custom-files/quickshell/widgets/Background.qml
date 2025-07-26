pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.components.internal as Private
import qs.theme

Scope {
    id: bgScope
    property var bar

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bgpanel
            required property var modelData
            screen: modelData
            color: "transparent"
            exclusiveZone: Theme.barHeight + Theme.debugOffsetHeight
            WlrLayershell.layer: WlrLayer.Background
            implicitHeight: screen.height

            anchors {
                left: true
                top: true
                right: true
            }

            Bar {
                id: mainBar
            }

            Private.Corner {
                rotation: 0
                x: Theme.padding
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.padding
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                rotation: 270
                anchors.right: parent.right
                anchors.rightMargin: Theme.padding
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.padding
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                rotation: 90
                x: Theme.padding
                y: Theme.barHeight + Theme.debugOffsetHeight
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                rotation: 180
                anchors.right: parent.right
                anchors.rightMargin: Theme.padding
                y: Theme.barHeight + Theme.debugOffsetHeight
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Rectangle {
                anchors.left: parent.left
                implicitHeight: parent.height
                implicitWidth: Theme.padding
                color: Theme.colors.background
            }

            Rectangle {
                anchors.bottom: parent.bottom
                implicitWidth: parent.width
                implicitHeight: Theme.padding
                color: Theme.colors.background
            }

            Rectangle {
                anchors.right: parent.right
                implicitHeight: parent.height
                implicitWidth: Theme.padding
                color: Theme.colors.background
            }
        }
    }
}
