import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.theme
import qs.services
import "internal" as Private

Button {
    id: networkPill

    implicitWidth: content.width + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - Theme.margin

    background: Rectangle {
        color: networkPill.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.pillMedium
        border {
            width: 2
            color: {
                if (!Network.isConnected)
                    return Qt.alpha(Theme.colors.error, 0.3);
                return Qt.alpha(Theme.colors.primary, 0.3);
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.anims.duration.small
                easing.type: Easing.OutQuad
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.anims.duration.normal
            }
        }
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: Theme.margin

        Text {
            Layout.minimumWidth: Theme.font.large
            horizontalAlignment: Qt.AlignHCenter
            font {
                family: Theme.font.family
                pixelSize: Theme.font.large
            }
            color: Network.isConnected ? Theme.colors.primary : Theme.colors.error
            text: Network.status

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.normal
                }
            }
        }

        Private.NetworkVisualizer {
            Layout.preferredWidth: Theme.playerWidth
            Layout.preferredHeight: networkPill.height - Theme.margin
        }
    }

    Private.ToolTipPopup {
        expandDirection: Edges.Bottom
        targetWidget: networkPill
        triggerTarget: true
        position: Qt.rect(networkPill.width / 2, networkPill.height + Theme.padding, 0, 0)

        ColumnLayout {
            spacing: Theme.margin / 2

            Private.StyledText {
                text: {
                    if (!Network.isConnected)
                        return "Not Connected";
                    if (Network.primaryType === "wifi") {
                        return `${Network.ssid} (${Network.signalStrength}%)`;
                    }
                    return `Ethernet (${Network.primaryInterface})`;
                }
                color: Theme.colors.on_surface
                font.weight: Font.Medium
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Theme.colors.outline_variant
                opacity: 0.3
                visible: Network.isConnected
            }

            RowLayout {
                visible: Network.isConnected
                spacing: Theme.padding

                ColumnLayout {
                    spacing: 2

                    Private.StyledText {
                        text: " Download"
                        color: Theme.colors.primary
                        font.pixelSize: Theme.font.small
                    }

                    Private.StyledText {
                        text: Network.formatRate(Network.rxRate)
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.smaller
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 30
                    color: Theme.colors.outline_variant
                    opacity: 0.3
                }

                ColumnLayout {
                    spacing: 2

                    Private.StyledText {
                        text: " Upload"
                        color: Theme.colors.secondary
                        font.pixelSize: Theme.font.small
                    }

                    Private.StyledText {
                        text: Network.formatRate(Network.txRate)
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.smaller
                    }
                }
            }

            Private.StyledText {
                visible: !Network.isConnected
                text: "Click to manage connections"
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.small
                opacity: 0.7
            }
        }
    }
}
