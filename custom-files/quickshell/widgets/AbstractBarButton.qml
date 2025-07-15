import QtQuick
import QtQuick.Controls

Button {
    id: barButton

    property bool menuOpen: false

    signal requestOpen

    function forceClose() {
        menuOpen = false;
    }

    action: Action {
        id: toggleMenuAction
        onTriggered: {
            if (barButton.menuOpen) {
                barButton.menuOpen = false;
            } else {
                barButton.requestOpen(); // Let the parent manage other open menus
                barButton.menuOpen = true;
            }
        }
    }
}
