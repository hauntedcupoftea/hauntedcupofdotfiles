import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32

            RowLayout {
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.fill: parent
                spacing: 8

                ClockWidget {
                    id: clockwidget
                }

                PowerMenu {
                    id: powermenu
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 32
                }
            }
        }
    }
}
