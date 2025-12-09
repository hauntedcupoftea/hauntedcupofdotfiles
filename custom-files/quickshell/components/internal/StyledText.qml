pragma ComponentBehavior: Bound

import QtQuick

import qs.theme

Text {
    id: root

    property color textColor: Theme.colors.on_surface
    property int weight: 500
    property int fontSize: Theme.font.normal
    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: Theme.anims.duration.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: textColor
    font.family: Theme.font.family
    font.pixelSize: fontSize
    font.weight: weight

    Behavior on color {
        ColorAnimation {
            duration: Theme.anims.duration.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Theme.anims.curve.standard
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve: Theme.anims.curve.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve: Theme.anims.curve.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
        easing.type: Easing.BezierSpline
    }
}
