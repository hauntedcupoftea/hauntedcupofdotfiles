pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root
    property real systemActivity: 0
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            root.systemActivity = Math.random();
            print(root.systemActivity);
        }
    }
}
