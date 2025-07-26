import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.theme
import qs.services

PopupWindow {
    id: root
    property var powerButton
    property bool popupOpen
    property string networkText: JSON.stringify(Network.availableNetworks, null, 2)
    anchor {
        item: powerButton
        rect: Qt.rect(powerButton.width / 2, powerButton.height + Theme.padding, 0, 0)
        gravity: Edges.Bottom
    }
    color: "transparent"

    implicitWidth: content.width + (Theme.padding * 2)
    implicitHeight: content.height + (Theme.padding * 2)
    visible: popupOpen

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.verysmall
        color: Theme.colors.surface_container_high
        border {
            width: 1
            color: Theme.colors.outline
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onExited: {
                root.powerButton.action.trigger();
            }
            ColumnLayout {
                id: content
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Theme.padding
                Text {
                    id: textSample
                    text: PowerProfile.toString(Battery.activeProfile)
                    color: Theme.colors.primary
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.normal
                        weight: 800
                    }
                }
                RowLayout {
                    id: profileSelector
                    Repeater {
                        model: [
                            {
                                profile: PowerProfile.PowerSaver,
                                icon: "󰌪",
                                color: Theme.colors.primary
                            },
                            {
                                profile: PowerProfile.Balanced,
                                icon: "󰘮",
                                color: Theme.colors.secondary
                            },
                            {
                                profile: PowerProfile.Performance,
                                icon: "󰓅",
                                color: Theme.colors.error
                            }
                        ]

                        Button {
                            id: selectorRoot
                            required property var modelData
                            implicitWidth: 48
                            implicitHeight: 48
                            background: Rectangle {
                                radius: Theme.rounding.small
                                color: {
                                    if (mouseArea.pressed)
                                        return Theme.colors.surface_container_high;
                                    if (mouseArea.containsMouse)
                                        return Theme.colors.surface_container;
                                    if (Battery.activeProfile === selectorRoot.modelData.profile)
                                        return selectorRoot.modelData.color + "40";
                                    return Theme.colors.surface;
                                }

                                border.width: Battery.activeProfile === selectorRoot.modelData.profile ? 2 : 0
                                border.color: selectorRoot.modelData.color
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {
                                    // Use your Battery service's setProfile function
                                    Battery.setProfile(selectorRoot.modelData.profile);
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: selectorRoot.modelData.icon
                                font.pixelSize: 18
                                color: Battery.activeProfile === selectorRoot.modelData.profile ? selectorRoot.modelData.color : Theme.colors.on_surface
                            }
                        }
                    }
                }
            }
        }
    }
}
