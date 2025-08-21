pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd dd | hh:mm");
    }
    readonly property string currentDate: {
        Qt.formatDate(clock.date, "ddd dd MMM, yyyy");
    }
    readonly property date rawtime: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
