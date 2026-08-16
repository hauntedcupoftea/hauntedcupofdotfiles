import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import Quickshell.Io

import qs.components
import qs.services

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: background
            color: "transparent"
            required property var modelData
            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            HyprlandFocusGrab {
                id: grab
                windows: [background]
            }

            ClockWidget {
                id: cock
                z: 2
                size: background.modelData.height / 8
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: background.modelData.height / 4
                }
            }
            DateWidget {
                id: dae
                z: 2
                size: cock.size / 3
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: cock.top
                    bottomMargin: dae.size / 10
                }
            }
            Rectangle {
                id: sessionRec
                color: "#44111111"
                z: 2
                border {
                    color: "#33967373"
                    width: 1
                }
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: dae.size
                    bottomMargin: dae.size
                }
                radius: 10
                implicitHeight: background.modelData.height / 12
                implicitWidth: background.modelData.width / 10
                SessionLayout {
                    id: layout
                    anchors.fill: parent
                    anchors.margins: 10
                    fontSize: dae.size * 0.8
                    butRadius: 10
                }
            }
            UserMenu {
                id: userssss
                z: 0
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: dae.size * 3
                }
                implicitWidth: background.modelData.width / 7
                delegateHeight: dae.size * 1.2
                fontSize: dae.size / 1.6
                onClicked: {
                    console.log("hi");
                    screen2.state = "open";
                }
                ParallelAnimation {
                    running: Greeterd.isAvailable && !Greeterd.inactive
                    NumberAnimation {
                        target: userssss
                        property: "opacity"
                        to: 0
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: userssss
                        property: "scale"
                        to: 0.6
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }
                SequentialAnimation {
                    running: Greeterd.isAvailable && Greeterd.inactive && screen2.state == ""
                    PauseAnimation {
                        duration: 200
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: userssss
                            property: "opacity"
                            to: 1
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: userssss
                            property: "scale"
                            to: 1
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
            LoginScreen {
                id: screen2
                z: 0
                MouseArea {
                    anchors.fill: parent
                    z: -1
                }
                anchors {
                    top: parent.bottom
                    left: parent.left
                    right: parent.right
                    bottom: undefined
                }
                screenHeight: background.modelData.height
                screenWidth: background.modelData.width
                butVisible: state === "open"
                onClick: state = ""
                states: State {
                    name: "open"
                    AnchorChanges {
                        target: screen2
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                    }
                }
                transitions: Transition {
                    ParallelAnimation {
                        AnchorAnimation {
                            duration: 400
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
            Connections {
                target: Greeterd
                function onAuthFailed() {
                    screen2.state = "";
                    Greeterd.resetMessages();
                }
                function onReadyToLaunch() {
                    screen2.state = "";
                    Greeterd.resetMessages();
                    if (Sessions.currentSession) {
                        const cmd = Sessions.currentSession.exec;
                        console.log("Launching:", cmd);
                        Greeterd.launch(cmd.split(' '));
                    } else {
                        console.error("No session selected or sessions still loading!");
                    }
                }
            }
            Text {
                id: placeholder
                text: "Launching ..."
                anchors.centerIn: parent
                opacity: Greeter.ready ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }
                color: "#967373"
            }
        }
    }
}
