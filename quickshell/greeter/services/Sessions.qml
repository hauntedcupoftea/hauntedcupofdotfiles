pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property alias model: sessionModel
    ListModel {
        id: sessionModel
    }

    property int currentIndex: 0
    property var currentSession: (model.count > 0 && currentIndex < model.count) ? model.get(currentIndex) : null

    Process {
        id: loader
        running: true

        command: ["sh", "-c", "awk -F= '/^Name=/{name=$2} /^Exec=/{exec=$2} ENDFILE {if(name && exec) print name \"|\" exec; name=\"\"; exec=\"\"}' /run/current-system/sw/share/wayland-sessions/*.desktop"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split('\n');
                lines.forEach(line => {
                    const parts = line.split('|');
                    if (parts.length >= 2) {
                        let cleanExec = parts[1].replace(/%[a-zA-Z]/g, "").trim();

                        sessionModel.append({
                            "name": parts[0].trim(),
                            "exec": cleanExec
                        });
                    }
                });

                console.log("Found", sessionModel.count, "sessions.");
            }
        }
    }
}
