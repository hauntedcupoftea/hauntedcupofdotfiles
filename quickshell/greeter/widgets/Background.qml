import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.components

Scope {
  Variants {
    model: Quickshell.screens
    // qmllint disable uncreatable-type
    PanelWindow {
      id: background
      color: "red"
      implicitHeight: 300
      implicitWidth: 300
      required property var modelData
      screen: modelData
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Top
      anchors {
        right: true
      }
      TheButton {
        anchors.centerIn: parent
      }
    }
  }
}
