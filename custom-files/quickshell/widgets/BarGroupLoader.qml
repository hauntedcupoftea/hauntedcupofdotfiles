import QtQuick
import QtQuick.Controls

Loader {
    id: menuLoader

    property bool menuOpen: item.menuOpen ?? false
    signal requestOpen

    function forceClose() {
        if (item && item.forceClose) {
            item.forceClose();
        }
    }

    onItemChanged: {
        if (item) {
            item.requestOpen.connect(menuLoader.requestOpen);

            item.menuOpenChanged.connect(function () {
                menuLoader.menuOpenChanged();
            });
        }
    }
}
