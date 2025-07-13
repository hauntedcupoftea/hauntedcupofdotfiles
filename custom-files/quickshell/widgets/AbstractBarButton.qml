import QtQuick
import QtQuick.Controls

Button {
    id: barButton

    property bool menuOpen: false

    signal requestOpen

    function forceClose() {
        menuOpen = false;
    }

    onClicked: {
        if (barButton.menuOpen) {
            barButton.menuOpen = false;
        } else {
            barButton.requestOpen();
            barButton.menuOpen = true;
        }
    }
}
