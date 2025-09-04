import QtQuick
import QtQuick.Controls

Button {
    id: barButton

    required property string sidebarComponent
    property bool menuOpen: false

    signal requestSidebarToggle

    function findParentBarGroup() {
        let current = parent;
        while (current) {
            if (current.toggleSidebar !== undefined) {
                return current;
            }
            current = current.parent;
        }
        return null;
    }

    // Connect to parent BarGroup's sidebar toggle signal
    onRequestSidebarToggle: {
        let parentGroup = findParentBarGroup();
        if (parentGroup && parentGroup.toggleSidebar) {
            parentGroup.toggleSidebar();
        }
    }

    // Safer component registration
    Component.onCompleted: {
        if (sidebarComponent) {
            let parentGroup = findParentBarGroup();
            if (parentGroup && parentGroup.registerSidebarComponent) {
                parentGroup.registerSidebarComponent(barButton);
            }
        }
    }

    Component.onDestruction: {
        if (sidebarComponent) {
            let parentGroup = findParentBarGroup();
            if (parentGroup && parentGroup.unregisterSidebarComponent) {
                parentGroup.unregisterSidebarComponent(barButton);
            }
        }
    }

    action: Action {
        id: toggleMenuAction
        onTriggered: {
            if (barButton.sidebarComponent) {
                barButton.requestSidebarToggle();
            }
        }
    }
}
