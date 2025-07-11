pragma ComponentBehavior: Bound

import QtQuick
import "../../theme"

Text {
    id: root

    property color textColor
    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: Theme.anims.duration.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: textColor ?? Theme.colors.text
    font.family: Theme.font.family
    font.pointSize: Theme.font.sizeBase

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
