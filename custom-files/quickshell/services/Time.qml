pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd dd | hh:mm");
    }
    readonly property string date: {
        Qt.formatDate(clock.date, "ddd dd MMM, yyyy");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
