pragma Singleton
import Quickshell
import Quickshell.Services.Greetd
import QtQuick

Singleton {
    id: root
    signal authFailed
    signal authMessage
    signal readyToLaunch
    property bool isAvailable: Greetd?.available
    property var state: Greetd?.state
    property string user: Greetd?.user
    property bool inactive: state == GreetdState.Inactive
    property bool authing: state == GreetdState.Authenticating
    property bool ready: state == GreetdState.ReadyToLaunch
    property bool isWorking: false
    property string message: ""
    property string minError: ""
    property string majError: ""
    property bool responseReq: false
    property bool showResponse: false

    function createSession(user) {
        if (isAvailable) {
            resetMessages();
            Greetd.createSession(user);
        }
    }

    function cancelSession() {
        resetMessages();
        Greetd.cancelSession();
    }

    function resetMessages() {
        message = "";
        minError = "";
        responseReq = false;
        showResponse = false;
        isWorking = false;
    }
    function respond(response) {
        if (responseReq) {
            Greetd.respond(response);
            root.isWorking = true;
        }
    }

    function launch(command) {
        if (ready)
            Greetd.launch(command);
    }

    Connections {
        target: Greetd
        function onAuthMessage(message, error, responseRequired, echoResponse) {
            root.isWorking = false;
            if (!error) {
                root.message = message;
                root.minError = "";
            } else if (error) {
                root.minError = message;
            }
            root.responseReq = responseRequired;
            root.showResponse = echoResponse;
            root.authMessage();
        }

        function onAuthFailure(mess) {
            root.majError = mess;
            root.isWorking = false;
            let timer = Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 1000; repeat: false }', root);
            timer.triggered.connect(() => {
                root.authFailed();
                timer.destroy();
            });
            timer.start();
        }
        function onReadyToLaunch() {
            root.isWorking = false;
            root.readyToLaunch();
        }
    }
}
