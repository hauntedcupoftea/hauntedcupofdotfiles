pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import "../components/internal" as Private
import "../components"

Scope {
    id: bgScope
    property var bar

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bgpanel
            property var modelData
            screen: modelData
            color: "transparent"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background

            anchors {
                left: true
                bottom: true
                top: true
                right: true
            }

            Private.Corner {
                rotation: 0
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                implicitHeight: 40
                implicitWidth: 40
            }
            Private.Corner {
                rotation: 270
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                implicitHeight: 40
                implicitWidth: 40
            }

            // TODO: learn how to align these to bar properly.
            Private.Corner {
                rotation: 90
                anchors.left: parent.left
                implicitHeight: 40
                implicitWidth: 40
            }
            Private.Corner {
                rotation: 180
                anchors.right: parent.right
                implicitHeight: 40
                implicitWidth: 40
            }
        }
    }
}
