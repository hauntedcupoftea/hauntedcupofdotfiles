import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services

Rectangle {
    id: root
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: colors.window

    Button {
        text: "Its not working, let me out"
        onClicked: LockContext.unlock()
    }

    Label {
        id: clock
        property var date: new Date()

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }

        renderType: Text.NativeRendering
        font.pointSize: 80

        Timer {
            running: true
            repeat: true
            interval: 1000

            onTriggered: clock.date = new Date()
        }

        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }

    ColumnLayout {

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }

        RowLayout {
            TextField {
                id: passwordBox

                implicitWidth: 400
                padding: 10

                focus: true
                enabled: !LockContext.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: LockContext.currentText = this.text

                onAccepted: LockContext.tryUnlock()

                Connections {
                    target: LockContext

                    function onCurrentTextChanged() {
                        passwordBox.text = LockContext.currentText;
                    }
                }
            }

            Button {
                text: "Unlock"
                padding: 10

                focusPolicy: Qt.NoFocus

                enabled: !LockContext.unlockInProgress && LockContext.currentText !== ""
                onClicked: LockContext.tryUnlock()
            }
        }

        Label {
            visible: LockContext.showFailure
            text: "Incorrect password"
        }
    }
}
