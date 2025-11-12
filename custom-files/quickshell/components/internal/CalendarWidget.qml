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

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        anchors.margins: 16
        currentIndex: calendarRoot.showMonthYearPicker ? 1 : 0

        ColumnLayout {
            spacing: 16

            RowLayout {
                Layout.fillWidth: true

                Button {
                    id: prevMonthButton
                    StyledText {
                        text: "‹"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                    }

                    flat: true
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    onClicked: {
                        if (calendar.month == 0)
                            calendar.year -= 1;
                        calendar.month = (calendar.month + 11) % 12;
                    }
                    background: Rectangle {
                        color: prevMonthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small
                    }
                }

                Button {
                    id: monthButton
                    Layout.fillWidth: true
                    text: Qt.formatDate(new Date(calendar.year, calendar.month), "MMMM yyyy")
                    flat: true
                    onClicked: calendarRoot.showMonthYearPicker = true

                    background: Rectangle {
                        color: monthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.verysmall
                    }

                    contentItem: Text {
                        text: monthButton.text
                        font {
                            family: Theme.font.family
                            pixelSize: 22
                            weight: Font.Medium
                        }
                        color: Theme.colors.on_surface
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Button {
                    id: nextMonthButton
                    StyledText {
                        text: "›"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                    }
                    flat: true
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    onClicked: {
                        if (calendar.month == 11)
                            calendar.year += 1;
                        calendar.month = (calendar.month + 1) % 12;
                    }
                    background: Rectangle {
                        color: nextMonthButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small
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
                        Layout.preferredHeight: 40
                        color: "transparent"
                        required property var modelData

                        Text {
                            anchors.centerIn: parent
                            text: dayLabels.modelData
                            font {
                                family: Theme.font.family
                                pixelSize: 14
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

                    radius: Theme.rounding.verysmall

                    color: {
                        if (isToday)
                            return Theme.colors.primary;
                        if (isHovered && isCurrentMonth)
                            return Theme.colors.surface_container_highest;
                        return "transparent";
                    }

                    Text {
                        anchors.centerIn: parent
                        text: dayCell.modelData.day
                        font {
                            family: Theme.font.family
                            pixelSize: 14
                            weight: dayCell.isToday ? Font.Medium : Font.Normal
                        }
                        color: {
                            if (dayCell.isToday)
                                return Theme.colors.on_primary;
                            if (!dayCell.isCurrentMonth)
                                return Theme.colors.on_surface_variant;
                            return Theme.colors.on_surface;
                        }
                        opacity: dayCell.isCurrentMonth ? 1.0 : 0.6
                    }

                    MouseArea {
                        id: dayMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
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
                text: "Today"
                flat: true
                onClicked: {
                    var today = new Date();
                    calendar.month = today.getMonth();
                    calendar.year = today.getFullYear();
                }
                background: Rectangle {
                    color: todayButton.hovered ? Theme.colors.primary_container : Theme.colors.surface_container_highest
                    radius: 20
                    border {
                        width: 1
                        color: Theme.colors.outline
                    }
                }
                contentItem: Text {
                    text: todayButton.text
                    font {
                        family: Theme.font.family
                        pixelSize: 14
                    }
                    color: Theme.colors.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        ColumnLayout {
            spacing: 24

            RowLayout {
                Layout.fillWidth: true

                Button {
                    id: prevButton
                    StyledText {
                        text: "←"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                    }
                    flat: true
                    Layout.preferredHeight: 48
                    Layout.preferredWidth: 48
                    onClicked: calendarRoot.showMonthYearPicker = false
                    background: Rectangle {
                        color: prevButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: "Select Month & Year"
                    font {
                        family: Theme.font.family
                        pixelSize: 22
                        weight: Font.Medium
                    }
                    color: Theme.colors.on_surface
                    horizontalAlignment: Text.AlignHCenter
                }

                Item {
                    Layout.preferredHeight: 48
                    Layout.preferredWidth: 48
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Button {
                    id: prevArrowButton
                    Layout.preferredHeight: 48
                    Layout.preferredWidth: 48
                    StyledText {
                        text: "‹"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                    }
                    flat: true
                    onClicked: calendar.year = calendar.year - 1
                    background: Rectangle {
                        color: prevArrowButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small
                    }
                }

                Text {
                    text: calendar.year
                    font {
                        family: Theme.font.family
                        pixelSize: 32
                        weight: Font.Medium
                    }
                    color: Theme.colors.on_surface
                }

                Button {
                    id: nextArrowButton
                    Layout.preferredHeight: 48
                    Layout.preferredWidth: 48
                    StyledText {
                        text: "›"
                        color: Theme.colors.on_surface
                        anchors.centerIn: parent
                    }
                    flat: true
                    onClicked: calendar.year = calendar.year + 1
                    background: Rectangle {
                        color: nextArrowButton.hovered ? Theme.colors.surface_container_highest : "transparent"
                        radius: Theme.rounding.small
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: 8
                columnSpacing: 8

                Repeater {
                    model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

                    Button {
                        id: gridMonthButton
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
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
                            radius: 12
                            border {
                                width: gridMonthButton.isSelected ? 2 : 1
                                color: gridMonthButton.isSelected ? Theme.colors.primary : Theme.colors.outline_variant
                            }
                        }

                        contentItem: Text {
                            text: gridMonthButton.text
                            font {
                                family: Theme.font.family
                                pixelSize: 14
                                weight: gridMonthButton.isSelected ? Font.Medium : Font.Normal
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
