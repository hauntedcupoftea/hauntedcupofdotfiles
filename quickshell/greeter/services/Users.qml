pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property alias userModel: userModel
    ListModel {
        id: userModel
    }
    property string output
    function updateUsersModel(commandOutput) {
        userModel.clear();
        var lines = commandOutput.trim().split("\n");
        for (var i = 0; i < lines.length; i++) {
            var username = lines[i].trim();
            if (username !== "") {
                userModel.append({
                    "nameRole": username
                });
            }
        }
    }
    Process {
        running: true
        command: ["sh", "-c", "awk -F: '$3 >= 1000 && $3 < 1010 {print $1}' /etc/passwd"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.updateUsersModel(this.text);
            }
        }
    }
}
