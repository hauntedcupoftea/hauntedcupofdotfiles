import QtQuick
import QtQuick.Controls

Button {
    id: barButton

    required property Component sidebarComponent

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

    // Safer component registration
    Component.onCompleted: {
        if (sidebarComponent) {
            let parentGroup = findParentBarGroup();
            if (parentGroup && parentGroup.registerSidebarComponent) {
                parentGroup.registerSidebarComponent(barButton);
            }
        }
    }

    action: Action {
        id: toggleMenuAction
        onTriggered: {
            if (barButton.sidebarComponent) {
                let parentGroup = barButton.findParentBarGroup();
                if (parentGroup && parentGroup.toggleSidebar) {
                    barButton.requestSidebarToggle();
                }
            }
        }
    }
}
