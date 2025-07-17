import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"
import "../config"
import Quickshell.Widgets
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
            model: SystemTray.items.values.filter(item => !Settings.ignoredTrayItems.includes(item.id))
            Button {
                id: sysTrayButton
                required property SystemTrayItem modelData
                implicitHeight: Theme.trayIconSize + Theme.margin
                implicitWidth: Theme.trayIconSize + Theme.margin
                background: Rectangle {
                    radius: Theme.rounding.full
                    color: sysTrayButton.hovered ? Theme.colors.surface0 : Theme.colors.mantle
                }

                IconImage {
                    anchors.centerIn: parent
                    source: sysTrayButton.modelData.icon //.split("?")[0]
                    implicitSize: Theme.trayIconSize
                }
                // DEBUG
                // Component.onCompleted: print(JSON.stringify(modelData))
            }
        }
    }
}
