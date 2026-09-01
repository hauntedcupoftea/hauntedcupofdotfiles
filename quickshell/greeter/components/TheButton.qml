import QtQuick
import QtQuick.Controls
import Quickshell.Widgets

Button {
  id: root
  property double size: 280
  property double fill: 0.3
  property double angle: 45

  implicitHeight: size
  implicitWidth: implicitHeight

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: root.fill = Math.random()
  }

  background: ClippingRectangle {
    color: "transparent"
    border.width: 1
    border.color: "grey"
    radius: root.size / 2

    ClippingRectangle {
      id: tiltedVessel
      anchors.fill: parent
      anchors.margins: parent.width * 0.144
      radius: 4
      color: "transparent"
      border.width: 1
      border.color: "grey"

      rotation: root.hovered ? 0 : root.angle
      scale: root.hovered ? 0.75 : 1.0
      transformOrigin: Item.Center

      Behavior on rotation {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutCubic
        }
      }
      Behavior on scale {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutCubic
        }
      }

      Item {
        id: levelFrame
        anchors.centerIn: parent
        implicitWidth: root.width
        implicitHeight: root.height
        rotation: -tiltedVessel.rotation

        Rectangle {
          id: liquid
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          height: parent.height * root.fill
          color: "darkblue"

          Behavior on height {
            NumberAnimation {
              duration: 400
              easing.type: Easing.OutQuad
            }
          }
        }
      }
    }
  }
}
