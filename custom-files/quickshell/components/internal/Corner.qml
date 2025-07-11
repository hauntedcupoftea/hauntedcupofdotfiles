import QtQuick
import QtQuick.Shapes
import "../../theme"

Item {
    id: root
    property real rotationAngle: 0
    property real curveDipAngle: 33

    Shape {
        id: shape
        asynchronous: true
        fillMode: Shape.PreserveAspectFit
        preferredRendererType: Shape.CurveRenderer
        anchors.fill: parent

        ShapePath {
            startX: 0
            startY: 0
            strokeWidth: -1
            fillColor: Theme.colors.base

            PathLine {
                x: 0
                y: root.height
            }
            PathLine {
                x: root.width
                y: root.height
            }
            PathArc {
                x: 0
                y: 0
                radiusX: root.curveDipAngle
                radiusY: root.curveDipAngle
            }
        }

        transform: Rotation {
            origin.x: shape.width / 2
            origin.y: shape.height / 2
            angle: root.rotationAngle
        }
    }
}
