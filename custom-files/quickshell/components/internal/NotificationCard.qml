pragma ComponentBehavior: Bound

import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme

import qs.config

Rectangle {
    id: notificationDelegate

    required property var n

    implicitWidth: Settings.notificationWidth
    implicitHeight: cardLayout.height + Theme.padding * 2
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface
    border.width: 1
    border.color: Theme.colors.outline_variant

    RowLayout {
        id: cardLayout
        anchors.centerIn: parent
        width: Settings.notificationWidth - (Theme.padding * 2)
        spacing: Theme.padding

        // App icon
        Rectangle {
            id: iconBox
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignTop
            radius: Theme.rounding.small
            color: Theme.colors.surface_variant

            Loader {
                anchors.centerIn: iconBox
                active: notificationDelegate.n && notificationDelegate.n?.appIcon
                sourceComponent: IconImage {
                    source: Quickshell.iconPath(notificationDelegate.n.appIcon)
                    implicitSize: 20
                }
            }
            Loader {
                anchors.centerIn: iconBox
                active: !notificationDelegate.n?.appIcon
                sourceComponent: StyledText {
                    text: "󰂚"
                    font.pixelSize: 20
                    color: Theme.colors.on_surface_variant
                }
            }
        }

        // Content area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: Theme.padding / 4

            // Header row
            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: notificationDelegate.n?.summary || "No Summary"
                    font.weight: Font.Medium
                    color: Theme.colors.on_surface
                    elide: Text.ElideRight
                }

                Text {
                    text: notificationDelegate.n?.receivedString || "󰛤"
                    font.pixelSize: Theme.font.small
                    color: Theme.colors.on_surface_variant
                }
            }

            // Body
            Text {
                Layout.fillWidth: true
                text: notificationDelegate.n?.body || ""
                color: Theme.colors.on_surface_variant
                wrapMode: Text.WordWrap
                visible: text !== ""
            }

            // Inline reply field
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.padding / 2
                visible: notificationDelegate.n?.n?.hasInlineReply || false

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    radius: Theme.rounding.small
                    color: Theme.colors.surface_variant
                    border.width: replyInput.activeFocus ? 2 : 1
                    border.color: replyInput.activeFocus ? Theme.colors.primary : Theme.colors.outline_variant

                    TextInput {
                        id: replyInput
                        anchors.fill: parent
                        anchors.margins: Theme.padding / 2
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.on_surface
                        font.pixelSize: Theme.font.normal

                        selectByMouse: true
                        wrapMode: TextInput.Wrap

                        Keys.onReturnPressed: sendReply()
                        Keys.onEnterPressed: sendReply()

                        function sendReply() {
                            if (text.trim() !== "" && notificationDelegate.n?.n?.sendInlineReply) {
                                notificationDelegate.n.n.sendInlineReply(text.trim());
                                text = "";
                            }
                        }
                    }

                    // Placeholder text when TextInput is empty
                    Text {
                        anchors.fill: replyInput
                        anchors.margins: Theme.padding / 2
                        verticalAlignment: Text.AlignVCenter
                        text: notificationDelegate.n?.n?.inlineReplyPlaceholder || "Reply..."
                        color: Theme.colors.on_surface_variant
                        font.pixelSize: Theme.font.normal
                        visible: replyInput.text === "" && !replyInput.activeFocus
                    }
                }

                // Send button
                Rectangle {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    radius: Theme.rounding.small
                    color: sendMouseArea.containsMouse ? Theme.colors.primary_container : Theme.colors.surface_variant
                    border.width: 1
                    border.color: Theme.colors.outline_variant

                    StyledText {
                        anchors.centerIn: parent
                        text: "󰒊" // Send icon
                        font.pixelSize: 16
                        color: sendMouseArea.containsMouse ? Theme.colors.on_primary_container : Theme.colors.on_surface_variant
                    }

                    MouseArea {
                        id: sendMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: replyInput.sendReply()
                    }
                }
            }

            // Actions (if any)
            Flow {
                Layout.fillWidth: true
                spacing: Theme.padding / 2
                visible: notificationDelegate.n?.actions?.length > 0

                Repeater {
                    model: notificationDelegate.n?.actions || []
                    delegate: Rectangle {
                        id: action
                        required property var modelData

                        height: 28
                        width: actionText.implicitWidth + Theme.padding
                        radius: Theme.rounding.small
                        color: Theme.colors.primary_container

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: action.modelData?.text || ""
                            color: Theme.colors.primary
                            font.pixelSize: Theme.font.small
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (action.modelData?.invoke) {
                                    action.modelData.invoke();
                                }
                            }
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: notificationDelegate.n?.appName || "Unknown app"
                color: Theme.colors.surface_bright
                font.pixelSize: Theme.font.small
                wrapMode: Text.WordWrap
                visible: text !== ""
            }
        }

        // Close button
        Rectangle {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignTop
            radius: 12
            color: closeMouseArea.containsMouse ? Theme.colors.error_container : "transparent"

            StyledText {
                anchors.centerIn: parent
                text: "󰅖"
                font.pixelSize: Theme.font.normal
                color: closeMouseArea.containsMouse ? Theme.colors.on_error_container : Theme.colors.on_surface_variant
            }

            MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (notificationDelegate.n?.n?.dismiss) {
                        notificationDelegate.n.n.dismiss();
                    }
                }
            }
        }
    }
}
