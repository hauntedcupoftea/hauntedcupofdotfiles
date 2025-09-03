pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.components.internal as Private
import qs.theme
import qs.config

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
                screenHeight: (bgpanel.screen.height - Theme.barHeight - (Theme.padding * 2))
                screenWidth: (bgpanel.screen.width - (Theme.padding * 2))
            }

            Private.Corner {
                visible: Settings.envelopeScreen || Settings.roundedBar
                rotation: 0
                x: Settings.envelopeScreen ? Theme.padding : 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Settings.envelopeScreen ? Theme.padding : 0
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                visible: Settings.envelopeScreen || Settings.roundedBar
                rotation: 270
                anchors.right: parent.right
                anchors.rightMargin: Settings.envelopeScreen ? Theme.padding : 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Settings.envelopeScreen ? Theme.padding : 0
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                visible: Settings.envelopeScreen || Settings.roundedBar
                rotation: 90
                x: Settings.envelopeScreen ? Theme.padding : 0
                y: Theme.barHeight + Theme.debugOffsetHeight
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Private.Corner {
                visible: Settings.envelopeScreen || Settings.roundedBar
                rotation: 180
                anchors.right: parent.right
                anchors.rightMargin: Settings.envelopeScreen ? Theme.padding : 0
                y: Theme.barHeight + Theme.debugOffsetHeight
                implicitHeight: Theme.padding
                implicitWidth: Theme.padding
            }

            Rectangle {
                visible: Settings.envelopeScreen
                anchors.left: parent.left
                implicitHeight: parent.height
                implicitWidth: Theme.padding
                color: Theme.colors.surface
            }

            Rectangle {
                visible: Settings.envelopeScreen
                anchors.bottom: parent.bottom
                implicitWidth: parent.width
                implicitHeight: Theme.padding
                color: Theme.colors.surface
            }

            Rectangle {
                visible: Settings.envelopeScreen
                anchors.right: parent.right
                implicitHeight: parent.height
                implicitWidth: Theme.padding
                color: Theme.colors.surface
            }
        }
    }
}
