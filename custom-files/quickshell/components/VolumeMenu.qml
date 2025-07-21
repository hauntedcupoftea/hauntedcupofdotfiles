pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell.Widgets
// import Quickshell.Services.Pipewire
import Quickshell

import qs.theme
import qs.services
import qs.widgets
import "internal" as Private

AbstractBarButton {
    id: root
    implicitHeight: Theme.barHeight - (Theme.margin)
    implicitWidth: Theme.playerWidth

    background: Loader {
        active: Audio.ready
        sourceComponent: Rectangle {
            radius: Theme.rounding.small
            color: Theme.colors.crust

            ClippingRectangle {
                id: content
                anchors.fill: parent
                anchors.margins: (Theme.margin / 1)
                radius: Theme.rounding.verysmall
                color: Theme.colors.mantle
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    implicitWidth: root.width * Audio.defaultOutput.audio.volume
                    color: Theme.colors.surface1
                }
            }
        }
    }

    // TODO: convey more information here.
    RowLayout {
        anchors.fill: root
        anchors.margins: (Theme.margin * 1)
        Private.StyledText {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: Theme.padding
            text: "󰕾"
            color: Theme.colors.text
            font.pixelSize: Theme.font.large
        }
        Private.StyledText {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.rightMargin: Theme.padding
            text: "󰍬"
            color: Theme.colors.text
            font.pixelSize: Theme.font.large
        }
    }

    MouseArea {
        id: wheelArea
        anchors.fill: parent
    }

    action: Action {
        onTriggered: print("No action assigned yet")
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(root.width / 2, root.height + Theme.padding, 0, 0)

        Text {
            text: JSON.stringify(Audio.defaultInput, null, 2)
            color: Theme.colors.text
        }
    }
}
