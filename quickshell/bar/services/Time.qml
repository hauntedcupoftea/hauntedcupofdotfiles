pragma Singleton

import Quickshell
import QtQuick
import qs.config

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, Settings.timeFormat);
    }
    readonly property string date: {
        Qt.formatDateTime(clock.date, Settings.dateFormat);
    }
    readonly property string currentDate: {
        Qt.formatDate(clock.date, Settings.fullDateFormat);
    }
    readonly property date rawtime: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
