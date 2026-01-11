pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: calendarRoot
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface_container
    border {
        width: 1
        color: Theme.colors.outline_variant
    }

    property bool showMonthYearPicker: false
    property date currentDate: new Date()
    property bool horizontal: true

    StackLayout {
        id: stackLayout
        anchors.centerIn: parent
        currentIndex: calendarRoot.showMonthYearPicker ? 1 : 0
        implicitHeight: calendarRoot.horizontal ? (parent.height - Theme.padding) : undefined
        implicitWidth: calendarRoot.horizontal ? undefined : (parent.width - Theme.padding)

        ColumnLayout {
            spacing: Theme.padding

            RowLayout {
                Layout.fillWidth: true

                Button {
                    id: prevMonthButton
                    Layout.preferredWidth: Theme.barHeight
                    Layout.preferredHeight: Theme.barHeight

                    StyledText {
                        text: "󰅁"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Theme.font.large
                    }

                    flat: true
                    onClicked: {
                        if (calendar.month == 0)
                            calendar.year -= 1;
                        calendar.month = (calendar.month + 11) % 12;
                    }

                    background: Rectangle {
                        color: prevMonthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }

                Button {
                    id: monthButton
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.barHeight
                    text: Qt.formatDate(new Date(calendar.year, calendar.month), "MMMM yyyy")
                    flat: true
                    onClicked: calendarRoot.showMonthYearPicker = true

                    background: Rectangle {
                        color: monthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }

                    contentItem: Text {
                        text: monthButton.text
                        font {
                            family: Theme.font.family
                            pixelSize: Theme.font.larger
                            weight: Font.Medium
                        }
                        color: Theme.colors.on_surface
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: nextMonthButton
                    Layout.preferredWidth: Theme.barHeight
                    Layout.preferredHeight: Theme.barHeight

                    StyledText {
                        text: "󰅂"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Theme.font.large
                    }

                    flat: true
                    onClicked: {
                        if (calendar.month == 11)
                            calendar.year += 1;
                        calendar.month = (calendar.month + 1) % 12;
                    }

                    background: Rectangle {
                        color: nextMonthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 7
                rowSpacing: 0
                columnSpacing: 0

                Repeater {
                    model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

                    Rectangle {
                        id: dayLabels
                        Layout.fillWidth: true
                        Layout.preferredHeight: Theme.barHeight - Theme.padding
                        color: "transparent"
                        required property var modelData

                        Text {
                            anchors.centerIn: parent
                            text: dayLabels.modelData
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.small
                                weight: Font.Medium
                            }
                            color: Theme.colors.on_surface_variant
                        }
                    }
                }
            }

            MonthGrid {
                id: calendar
                Layout.fillWidth: true
                Layout.fillHeight: true

                month: calendarRoot.currentDate.getMonth()
                year: calendarRoot.currentDate.getFullYear()

                property date today: new Date()

                delegate: Rectangle {
                    id: dayCell
                    required property var modelData

                    property bool isToday: modelData.day === calendar.today.getDate() && modelData.month === calendar.today.getMonth() && modelData.year === calendar.today.getFullYear()
                    property bool isCurrentMonth: modelData.month === calendar.month
                    property bool isHovered: dayMouseArea.containsMouse

                    radius: Theme.rounding.small

                    color: {
                        if (isToday)
                            return Theme.colors.primary;
                        if (isHovered && isCurrentMonth)
                            return Theme.colors.surface_container_highest;
                        return "transparent";
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: dayCell.modelData.day
                        font {
                            family: Theme.font.family
                            pixelSize: Theme.font.normal
                            weight: dayCell.isToday ? Font.Bold : Font.Normal
                        }
                        color: {
                            if (dayCell.isToday)
                                return Theme.colors.on_primary;
                            if (!dayCell.isCurrentMonth)
                                return Theme.colors.on_surface_variant;
                            return Theme.colors.on_surface;
                        }
                        opacity: dayCell.isCurrentMonth ? 1.0 : 0.5
                    }

                    MouseArea {
                        id: dayMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: dayCell.isCurrentMonth ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (dayCell.isCurrentMonth) {
                                console.log("Selected date:", Qt.formatDate(dayCell.modelData.date, "yyyy-MM-dd"));
                            }
                        }
                    }
                }
            }

            Button {
                id: todayButton
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: Theme.barHeight - Theme.margin
                implicitWidth: todayText.implicitWidth + (Theme.padding * 2)

                flat: true
                onClicked: {
                    const today = new Date();
                    calendar.month = today.getMonth();
                    calendar.year = today.getFullYear();
                }

                background: Rectangle {
                    color: todayButton.hovered ? Theme.colors.primary_container : Theme.colors.surface_container_highest
                    radius: Theme.rounding.pillMedium
                    border {
                        width: 1
                        color: Theme.colors.outline_variant
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.anims.duration.small
                        }
                    }
                }

                contentItem: Text {
                    id: todayText
                    text: "Today"
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.normal
                        weight: Font.Medium
                    }
                    color: todayButton.hovered ? Theme.colors.on_primary_container : Theme.colors.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        ColumnLayout {
            spacing: Theme.padding

            RowLayout {
                Layout.fillWidth: true

                Button {
                    id: backButton
                    Layout.preferredHeight: Theme.barHeight
                    Layout.preferredWidth: Theme.barHeight

                    StyledText {
                        text: "󰅁"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Theme.font.large
                    }

                    flat: true
                    onClicked: calendarRoot.showMonthYearPicker = false

                    background: Rectangle {
                        color: backButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: "Select Month & Year"
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.larger
                        weight: Font.Medium
                    }
                    color: Theme.colors.on_surface
                    horizontalAlignment: Text.AlignHCenter
                }

                Item {
                    Layout.preferredHeight: Theme.barHeight
                    Layout.preferredWidth: Theme.barHeight
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Button {
                    id: prevYearButton
                    Layout.preferredHeight: Theme.barHeight
                    Layout.preferredWidth: Theme.barHeight

                    StyledText {
                        text: "󰅁"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Theme.font.large
                    }

                    flat: true
                    onClicked: calendar.year = calendar.year - 1

                    background: Rectangle {
                        color: prevYearButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }

                Text {
                    text: calendar.year
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.huge
                        weight: Font.Medium
                    }
                    color: Theme.colors.on_surface
                }

                Button {
                    id: nextYearButton
                    Layout.preferredHeight: Theme.barHeight
                    Layout.preferredWidth: Theme.barHeight

                    StyledText {
                        text: "󰅂"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Theme.font.large
                    }

                    flat: true
                    onClicked: calendar.year = calendar.year + 1

                    background: Rectangle {
                        color: nextYearButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anims.duration.small
                            }
                        }
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: Theme.margin
                columnSpacing: Theme.margin

                Repeater {
                    model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

                    Button {
                        id: gridMonthButton
                        required property var modelData
                        required property int index

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Theme.barHeight

                        text: modelData

                        property bool isSelected: index === calendar.month

                        background: Rectangle {
                            color: {
                                if (gridMonthButton.isSelected)
                                    return Theme.colors.primary_container;
                                if (gridMonthButton.hovered)
                                    return Theme.colors.surface_container_highest;
                                return Theme.colors.surface_container;
                            }
                            radius: Theme.rounding.small
                            border {
                                width: gridMonthButton.isSelected ? 2 : 1
                                color: gridMonthButton.isSelected ? Theme.colors.primary : Theme.colors.outline_variant
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.anims.duration.small
                                }
                            }
                        }

                        contentItem: Text {
                            text: gridMonthButton.text
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.normal
                                weight: gridMonthButton.isSelected ? Font.Bold : Font.Normal
                            }
                            color: gridMonthButton.isSelected ? Theme.colors.on_primary_container : Theme.colors.on_surface
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            calendar.month = index;
                            calendarRoot.showMonthYearPicker = false;
                        }
                    }
                }
            }
        }
    }
}
