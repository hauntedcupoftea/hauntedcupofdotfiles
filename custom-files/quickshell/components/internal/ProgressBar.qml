pragma ComponentBehavior: Bound

import QtQuick
import qs.theme
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property real value: 0.0
    property bool active: true
    property bool indeterminate: false

    property bool shimmerEnabled: true
    property bool enableSmoothing: true

    property color backgroundColor: Theme.colors.surface_container
    property color accentColor: Theme.colors.primary
    property color borderColor: Qt.alpha(Theme.colors.outline_variant, 0.4)
    property real radius: Theme.rounding.verysmall
    property real borderWidth: 1

    default property alias content: contentHook.data

    implicitHeight: 24
    implicitWidth: 200

    Rectangle {
        id: track
        anchors.fill: parent
        color: root.backgroundColor
        radius: root.radius
        border.width: root.borderWidth
        border.color: root.borderColor

        Item {
            id: contentHook
            anchors.fill: parent
        }
    }

    Item {
        id: progressContainer
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        width: {
            if (root.indeterminate)
                return parent.width * 0.3;
            return Math.max(parent.width * Math.min(Math.max(root.value, 0.0), 1.0), 0);
        }

        Behavior on width {
            enabled: !root.indeterminate && root.enableSmoothing
            NumberAnimation {
                duration: Theme.anims.duration.normal
                easing.type: Easing.OutCubic
            }
        }

        x: 0
        SequentialAnimation on x {
            running: root.indeterminate && root.active
            loops: Animation.Infinite
            NumberAnimation {
                to: root.width - progressContainer.width
                duration: 800
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                to: 0
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: progressMask
        }

        Rectangle {
            id: progressMask
            anchors.fill: parent
            radius: root.radius
            visible: false
        }

        Rectangle {
            id: fillContent
            anchors.fill: parent

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0.0
                    color: Qt.alpha(root.accentColor, 0.3)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.alpha(root.accentColor, 0.1)
                }
            }

            Item {
                id: shimmerItem
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.height * 2

                visible: root.active && root.shimmerEnabled && !root.indeterminate && root.value > 0

                x: -width

                Rectangle {
                    anchors.fill: parent
                    rotation: 20
                    scale: 1.5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            color: "transparent"
                        }
                        GradientStop {
                            position: 0.5
                            color: Qt.alpha(root.accentColor, 0.5)
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }

                NumberAnimation on x {
                    running: shimmerItem.visible
                    from: -shimmerItem.width
                    to: progressContainer.width + shimmerItem.width
                    duration: 1500
                    loops: Animation.Infinite
                }
            }
        }
    }
}
