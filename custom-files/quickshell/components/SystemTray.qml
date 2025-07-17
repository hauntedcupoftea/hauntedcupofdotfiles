import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"
// import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: systemTray
    radius: Theme.rounding.small
    implicitWidth: sysTrayRow.width + (Theme.padding)
    implicitHeight: Theme.barHeight - (Theme.margin)
    color: Theme.colors.crust
    RowLayout {
        id: sysTrayRow
        anchors.centerIn: parent
        spacing: Theme.margin / 2
        Repeater {
            model: SystemTray.items.values
            Button {
                id: sysTrayButton
                required property SystemTrayItem modelData
                implicitHeight: Theme.barIconSize
                implicitWidth: Theme.barIconSize
                background: Rectangle {
                    radius: Theme.rounding.full
                    color: Theme.colors.mantle
                }

                Image {
                    anchors.centerIn: parent
                    source: sysTrayButton.modelData.icon
                    sourceSize: Qt.size(Theme.barIconSize - Theme.margin, Theme.barIconSize - Theme.margin)
                }
                // DEBUG
                // Component.onCompleted: print(JSON.stringify(modelData))
            }
        }
    }
}
