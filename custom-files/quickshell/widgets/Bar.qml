import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../theme"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData
            color: Theme.colors.base

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

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
    }
}
