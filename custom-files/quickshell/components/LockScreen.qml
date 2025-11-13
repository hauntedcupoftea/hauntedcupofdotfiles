pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import qs.services
import qs.theme

Rectangle {
    id: root
    color: Theme.colors.background
    property int length: passwordBox.length
    property list<string> charShapes: ['󰠖', '', '󱓻', '󰜡', '󰮊', '󰝬', '󰜁']

    // Gradient overlay for depth
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.rgba(0, 0, 0, 0)
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(0, 0, 0, 0.3)
            }
        }
    }

    // Clock
    Label {
        id: clock
        property var date: new Date()
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 80
        }
        renderType: Text.NativeRendering
        font.pointSize: 90
        font.weight: Font.Light
        color: Theme.colors.on_background

        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }

        text: {
            const hours = clock.date.getHours().toString().padStart(2, '0');
            const minutes = clock.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }

    // Date
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: clock.bottom
            topMargin: 10
        }
        renderType: Text.NativeRendering
        font.pointSize: 16
        color: Theme.colors.on_surface_variant
        text: {
            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
            return `${days[clock.date.getDay()]}, ${months[clock.date.getMonth()]} ${clock.date.getDate()}`;
        }
    }

    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
            topMargin: 50
        }
        spacing: 30

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 500
            implicitHeight: 80
            radius: 40
            color: Theme.colors.surface_container_high
            border.color: passwordBox.activeFocus ? Theme.colors.primary : Theme.colors.outline_variant
            border.width: 2

            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }

            TextInput {
                id: passwordBox
                anchors.fill: parent
                visible: false
                enabled: !LockContext.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                onTextChanged: LockContext.currentText = this.text
                onAccepted: LockContext.tryUnlock()
                focus: true

                Connections {
                    target: LockContext
                    function onCurrentTextChanged() {
                        passwordBox.text = LockContext.currentText;
                    }
                }
            }

            Row {
                id: dotsRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    leftMargin: 4
                }
                spacing: 10
                Behavior on x {
                    animation: Theme.anims.animation.elementMoveFast.numberAnimation.createObject(dotsRow.left)
                }
                Repeater {
                    model: ScriptModel {
                        values: Array(passwordBox.length)
                    }
                    delegate: Item {
                        id: charItem
                        required property int index
                        implicitWidth: 10
                        implicitHeight: 10
                        Text {
                            id: materialShape
                            anchors.centerIn: parent
                            text: root.charShapes[Math.abs(charItem.index) % root.charShapes.length]
                            color: Theme.colors.secondary
                            opacity: 0
                            scale: 0.5
                            Component.onCompleted: {
                                appearAnim.start();
                            }
                            ParallelAnimation {
                                id: appearAnim
                                NumberAnimation {
                                    target: materialShape
                                    properties: "opacity"
                                    to: 1
                                    duration: 50
                                    easing.type: Theme.anims.animation.elementMoveFast.type
                                    easing.bezierCurve: Theme.anims.animation.elementMoveFast.bezierCurve
                                }
                                NumberAnimation {
                                    target: materialShape
                                    properties: "scale"
                                    to: 1
                                    duration: 200
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Theme.anims.curve.expressiveFastSpatial
                                }
                                NumberAnimation {
                                    target: materialShape
                                    properties: "font.pixelSize"
                                    to: 18
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Theme.anims.curve.expressiveFastSpatial
                                }
                                ColorAnimation {
                                    target: materialShape
                                    properties: "color"
                                    from: Theme.colors.primary
                                    to: Theme.colors.on_surface
                                    duration: 1000
                                    easing.type: Theme.anims.animation.elementMoveFast.type
                                    easing.bezierCurve: Theme.anims.animation.elementMoveFast.bezierCurve
                                }
                            }
                        }
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                visible: passwordBox.text.length === 0
                text: "Enter password"
                color: Theme.colors.on_surface_variant
                font.pointSize: 14
                opacity: 0.6
            }

            MouseArea {
                anchors.fill: parent
                onClicked: passwordBox.forceActiveFocus()
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            Rectangle {
                implicitWidth: 50
                implicitHeight: 50
                radius: 25
                color: clearMouseArea.pressed ? Theme.colors.surface_container_highest : Theme.colors.surface_container_high
                border.color: Theme.colors.outline_variant
                border.width: 1
                visible: passwordBox.text.length > 0

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: "×"
                    font.pointSize: 24
                    color: Theme.colors.on_surface
                }

                MouseArea {
                    id: clearMouseArea
                    anchors.fill: parent
                    onClicked: {
                        passwordBox.text = "";
                        passwordBox.forceActiveFocus();
                    }
                }
            }

            Rectangle {
                implicitWidth: 200
                implicitHeight: 50
                radius: 25
                color: unlockMouseArea.pressed ? Theme.colors.primary_container : Theme.colors.primary
                enabled: !LockContext.unlockInProgress && LockContext.currentText !== ""
                opacity: enabled ? 1.0 : 0.5

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Label {
                        text: LockContext.unlockInProgress ? "Unlocking..." : "Unlock"
                        font.pointSize: 14
                        font.weight: Font.Medium
                        color: Theme.colors.on_primary
                    }

                    Rectangle {
                        visible: LockContext.unlockInProgress
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 10
                        color: "transparent"
                        border.color: Theme.colors.on_primary
                        border.width: 2

                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: Theme.colors.on_primary
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 2
                        }

                        RotationAnimation on rotation {
                            running: LockContext.unlockInProgress
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                        }
                    }
                }

                MouseArea {
                    id: unlockMouseArea
                    anchors.fill: parent
                    enabled: parent.enabled
                    onClicked: LockContext.tryUnlock()
                }
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            visible: LockContext.showFailure
            implicitWidth: errorLabel.implicitWidth + 30
            implicitHeight: 40
            radius: 20
            color: Theme.colors.error_container

            Label {
                id: errorLabel
                anchors.centerIn: parent
                text: "✗ Incorrect password"
                color: Theme.colors.on_error_container
                font.pointSize: 12
            }

            SequentialAnimation on Layout.leftMargin {
                running: LockContext.showFailure
                NumberAnimation {
                    from: 0
                    to: -10
                    duration: 50
                }
                NumberAnimation {
                    from: -10
                    to: 10
                    duration: 100
                }
                NumberAnimation {
                    from: 10
                    to: -10
                    duration: 100
                }
                NumberAnimation {
                    from: -10
                    to: 0
                    duration: 50
                }
            }
        }
    }

    Rectangle {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 40
        }
        implicitWidth: emergencyLabel.implicitWidth + 40
        implicitHeight: 45
        radius: 22.5
        color: emergencyMouseArea.pressed ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        border.color: Theme.colors.outline_variant
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        Label {
            id: emergencyLabel
            anchors.centerIn: parent
            text: "Emergency unlock"
            color: Theme.colors.on_surface_variant
            font.pointSize: 11
        }

        MouseArea {
            id: emergencyMouseArea
            anchors.fill: parent
            onClicked: LockContext.unlock()
        }
    }
}
