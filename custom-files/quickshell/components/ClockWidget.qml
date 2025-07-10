import QtQuick
import Theme
import Services 1.0

Rectangle {
    id: root
    color: Theme.base
    radius: Theme.rounding.verysmall
    width: clockText.implicitWidth + (Theme.padding * 2)
    height: 32

    Text {
        id: clockText
        text: Time.time
        anchors.centerIn: parent
        color: Theme.text
        font {
            family: Theme.font.family
            pixelSize: Theme.font.sizeBase
            weight: 700
        }
    }
}
