pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam

Singleton {
    id: root
    signal unlocked
    signal failed

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property bool locked: false

    function unlock() {
        root.locked = false;
        root.unlocked();
    }

    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (currentText === "")
            return;

        root.unlockInProgress = true;
        pam.start();
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            root.locked = true;
        }
    }

    PamContext {
        id: pam

        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
                root.locked = false;
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }
}
