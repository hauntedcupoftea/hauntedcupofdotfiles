pragma ComponentBehavior: Bound

import QtQuick
import qs.theme
import qs.services

Rectangle {
    id: calendarRoot
    radius: Theme.rounding.verysmall
    color: Theme.colors.surface_container
    border {
        width: 1
        color: Theme.colors.outline_variant
    }

    StyledText {
        text: JSON.stringify(Weather.forecast ?? {}, null, 2) ?? ""
    }
}
