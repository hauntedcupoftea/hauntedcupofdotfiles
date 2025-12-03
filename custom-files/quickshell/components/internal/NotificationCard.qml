pragma ComponentBehavior: Bound

import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: notificationCard

    required property var n

    enum Urgency {
        Low = 0,
        Normal = 1,
        Critical = 2
    }

    implicitHeight: cardContent.height + Theme.padding * 2
    radius: Theme.rounding.notification

    Rectangle {
        id: cardShadow

        anchors.fill: parent
        anchors.topMargin: Theme.margin / 2
        anchors.leftMargin: Theme.margin / 4
        radius: parent.radius
        color: Theme.colors.shadow
        opacity: 0.15
        z: -1
    }

    color: {
        if (notificationCard.n?.urgency === NotificationCard.Urgency.Critical)
            return Theme.colors.error_container;
        return Theme.colors.surface_container;
    }

    border.width: 1
    border.color: {
        if (notificationCard.n?.urgency === NotificationCard.Urgency.Critical)
            return Theme.colors.error;
        return Theme.colors.primary;
    }

    RowLayout {
        id: cardContent
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Theme.padding
        implicitWidth: notificationCard.width
        spacing: Theme.padding

        Rectangle {
            id: appIconPill
            Layout.preferredWidth: Theme.notificationIconSize
            Layout.preferredHeight: Theme.notificationIconSize
            Layout.alignment: Qt.AlignTop
            radius: Theme.rounding.pillMedium

            color: Theme.colors.primary_container

            Loader {
                anchors.centerIn: appIconPill
                active: notificationCard.n && notificationCard.n?.appIcon
                sourceComponent: IconImage {
                    source: notificationCard.n.image || Quickshell.iconPath(notificationCard.n.appIcon)
                    implicitSize: Theme.notificationImageSize
                }
            }
            Loader {
                anchors.centerIn: appIconPill
                active: !notificationCard.n?.appIcon
                sourceComponent: StyledText {
                    text: "󰂚"
                    font.pixelSize: Theme.barIconSize
                    color: Theme.colors.on_primary_container
                }
            }
        }

        ColumnLayout {
            id: notificationContent
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: Theme.margin

            RowLayout {
                id: notificationHeader

                Layout.fillWidth: true
                spacing: Theme.margin

                Text {
                    id: notificationSummary

                    Layout.fillWidth: true
                    text: notificationCard.n?.summary || "No Summary"
                    font.weight: Font.Bold
                    font.pixelSize: Theme.font.normal
                    color: Theme.colors.on_surface
                    elide: Text.ElideRight
                }

                Rectangle {
                    id: timeBadge
                    Layout.preferredHeight: Theme.notificationBadgeHeight
                    Layout.preferredWidth: timeBadge.implicitWidth + (Theme.padding * 4)
                    radius: Theme.rounding.pillSmall
                    color: Theme.colors.secondary_container

                    Text {
                        id: timeText
                        anchors.centerIn: parent
                        text: notificationCard.n?.receivedString || "now"
                        font.pixelSize: Theme.font.smaller
                        font.weight: Font.Medium
                        color: Theme.colors.on_secondary_container
                    }
                }
            }

            Text {
                id: notificationBody
                Layout.fillWidth: true
                text: notificationCard.n?.body || ""
                color: Theme.colors.on_surface_variant
                font.pixelSize: Theme.font.small
                wrapMode: Text.WordWrap
                visible: text !== ""
                maximumLineCount: 3
                elide: Text.ElideRight
            }

            RowLayout {
                id: inlineReply
                Layout.fillWidth: true
                spacing: Theme.margin
                visible: notificationCard.n?.n?.hasInlineReply || false

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.notificationActionHeight
                    radius: Theme.rounding.pillMedium
                    color: Theme.colors.surface_bright
                    border.width: replyInput.activeFocus ? 2 : 1
                    border.color: replyInput.activeFocus ? Theme.colors.primary : Qt.alpha(Theme.colors.outline, 0.5)

                    Behavior on border.color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
                        }
                    }

                    TextInput {
                        id: replyInput
                        anchors.fill: parent
                        anchors.margins: Theme.padding
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.on_surface
                        font.pixelSize: Theme.font.small

                        selectByMouse: true
                        wrapMode: TextInput.Wrap

                        Keys.onReturnPressed: sendReply()
                        Keys.onEnterPressed: sendReply()

                        function sendReply() {
                            if (text.trim() !== "" && notificationCard.n?.n?.sendInlineReply) {
                                notificationCard.n.n.sendInlineReply(text.trim());
                                text = "";
                            }
                        }
                    }

                    Text {
                        anchors.fill: replyInput
                        anchors.margins: Theme.padding
                        verticalAlignment: Text.AlignVCenter
                        text: notificationCard.n?.n?.inlineReplyPlaceholder || "Reply..."
                        color: Qt.alpha(Theme.colors.on_surface_variant, 0.6)
                        font.pixelSize: Theme.font.small
                        visible: replyInput.text === "" && !replyInput.activeFocus
                    }
                }

                Rectangle {
                    id: sendButton
                    Layout.preferredWidth: Theme.notificationActionHeight
                    Layout.preferredHeight: Theme.notificationActionHeight
                    radius: Theme.rounding.full

                    color: sendMouseArea.containsMouse ? Theme.colors.primary : Theme.colors.primary_container

                    border.width: 1
                    border.color: Theme.colors.primary

                    StyledText {
                        anchors.centerIn: parent
                        text: "󰒊"
                        font.pixelSize: Theme.font.normal
                        color: sendMouseArea.containsMouse ? Theme.colors.on_primary : Theme.colors.on_primary_container
                    }

                    MouseArea {
                        id: sendMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: replyInput.sendReply()
                    }
                }
            }

            Flow {
                id: actionFlow
                Layout.fillWidth: true
                spacing: Theme.margin
                visible: notificationCard.n?.actions?.length > 0

                Repeater {
                    model: notificationCard.n?.actions || []
                    delegate: Rectangle {
                        id: action
                        required property var modelData

                        height: Theme.font.normal + Theme.padding
                        width: actionText.implicitWidth + Theme.padding * 2
                        radius: Theme.rounding.pillSmall

                        color: actionMouseArea.containsMouse ? Theme.colors.secondary : Theme.colors.secondary_container

                        scale: actionMouseArea.pressed ? 0.95 : 1.0

                        Behavior on scale {
                            NumberAnimation {
                                duration: Theme.anims.duration.small
                                easing.type: Easing.OutBack
                            }
                        }

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: action.modelData?.text || ""
                            color: Theme.colors.on_secondary_container
                            font.pixelSize: Theme.font.small
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: actionMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (action.modelData?.invoke) {
                                    action.modelData.invoke();
                                }
                            }
                        }
                    }
                }
            }

            // App name badge
            Rectangle {
                Layout.preferredHeight: Theme.font.smallest + Theme.margin
                Layout.preferredWidth: appNameText.implicitWidth + (Theme.padding * 2)
                radius: Theme.rounding.unsharpenmore
                color: Theme.colors.tertiary_container
                visible: Boolean(notificationCard.n?.appName)

                Text {
                    id: appNameText
                    anchors.centerIn: parent
                    text: notificationCard.n?.appName || ""
                    color: Theme.colors.on_tertiary_container
                    font.pixelSize: Theme.font.smallest
                }
            }
        }

        // Close button - circular pill
        Rectangle {
            Layout.preferredWidth: Theme.font.large + Theme.padding
            Layout.preferredHeight: Theme.font.large + Theme.padding
            Layout.alignment: Qt.AlignTop
            radius: Theme.rounding.full

            color: closeMouseArea.containsMouse ? Theme.colors.error_container : Qt.alpha(Theme.colors.surface_container_highest, 0.6)

            border.width: 2
            border.color: closeMouseArea.containsMouse ? Theme.colors.error : Qt.alpha(Theme.colors.outline, 0.3)

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anims.duration.small
                }
            }

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
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (notificationCard.n?.n?.dismiss) {
                        notificationCard.n.n.dismiss();
                    }
                }
            }
        }
    }
}
