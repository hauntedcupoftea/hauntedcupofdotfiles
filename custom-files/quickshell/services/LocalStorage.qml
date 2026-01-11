pragma Singleton

import QtQuick.LocalStorage
import Quickshell
import QtQuick

Singleton {
    property var db: LocalStorage.openDatabaseSync("QuickshellBarDB")
}
