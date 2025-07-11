import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../theme"

Rectangle {
    id: bar
    property var modelData
    color: Theme.colors.base

    anchors {
        top: parent.top
        topMargin: Theme.debugOffsetHeight // remove in prod
        left: parent.left
        right: parent.right
    }

    implicitHeight: Theme.barHeight

    RowLayout {
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        anchors.fill: parent
        spacing: 2

        ClockWidget {
            id: clockwidget
        }

        //...more elements

        PowerMenu {
            id: powermenu
            Layout.alignment: Qt.AlignRight
        }
    }
}
