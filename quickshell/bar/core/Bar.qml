import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: Theme.colors[0]

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 12
                    rightMargin: 12
                }

                Text {
                    text: "bar"
                    color: Theme.colors[8]
                    font.pixelSize: 13
                    font.bold: true
                }

                Text {
                    text: Network.status
                    color: Theme.colors[7]
                    font.pixelSize: 12
                    Layout.leftMargin: 8
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: Time.date
                    color: Theme.colors[8]
                    font.pixelSize: 12
                }

                Text {
                    text: Time.time
                    color: Theme.colors[7]
                    font.pixelSize: 13
                    font.bold: true
                    Layout.leftMargin: 8
                }
            }
        }
    }
}
