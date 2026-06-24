import qs.services
import qs.theme
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: layoutPill
    Layout.fillHeight: true
    Layout.preferredWidth: layoutContent.width + (Theme.margin * 1.5)
    radius: Theme.rounding.pillSmall

    color: KeyboardLayout.isNonLatin ? Qt.alpha(Theme.colors.tertiary_container, 0.9) : Qt.alpha(Theme.colors.secondary_container, 0.7)

    Behavior on color {
        ColorAnimation {
            duration: Theme.anims.duration.normal
            easing.type: Easing.OutQuad
        }
    }

    scale: layoutMouseArea.pressed ? 0.95 : (layoutMouseArea.containsMouse ? 1.05 : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Theme.anims.duration.small
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }
    }

    Row {
        id: layoutContent
        anchors.centerIn: parent
        spacing: Theme.margin * 0.75

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: Theme.barIconSize
            implicitWidth: Theme.barIconSize + Theme.margin
            radius: Theme.rounding.pillSmall

            color: KeyboardLayout.isNonLatin ? Theme.colors.tertiary : Theme.colors.secondary

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.normal
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                id: icon
                anchors.centerIn: parent
                text: ""
                color: KeyboardLayout.isNonLatin ? Theme.colors.on_tertiary : Theme.colors.on_secondary
                font {
                    family: Theme.font.family
                    pixelSize: Theme.font.small
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anims.duration.normal
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: KeyboardLayout.displayText
            font {
                pixelSize: Theme.font.normal
                family: Theme.font.family
                weight: 600
                letterSpacing: 0.5
            }
            color: KeyboardLayout.isNonLatin ? Theme.colors.on_tertiary_container : Theme.colors.on_secondary_container

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.normal
                    easing.type: Easing.OutQuad
                }
            }

            layer.enabled: true
            layer.smooth: true
            layer.textureSize: Qt.size(width * 2, height * 2)
        }
    }

    MouseArea {
        id: layoutMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: KeyboardLayout.toggle()
    }

    SequentialAnimation {
        id: layoutChangePulse
        running: false

        ParallelAnimation {
            NumberAnimation {
                target: layoutPill
                property: "scale"
                to: 1.15
                duration: 150
                easing.type: Easing.OutQuad
            }
            ColorAnimation {
                target: layoutPill
                property: "color"
                to: KeyboardLayout.isNonLatin ? Theme.colors.tertiary_container : Theme.colors.secondary_container
                duration: 150
            }
        }

        NumberAnimation {
            target: layoutPill
            property: "scale"
            to: 1.0
            duration: 200
            easing.type: Easing.OutBack
            easing.overshoot: 1.3
        }
    }

    Connections {
        target: KeyboardLayout
        function onLayoutChanged() {
            layoutChangePulse.restart();
        }
    }
}
