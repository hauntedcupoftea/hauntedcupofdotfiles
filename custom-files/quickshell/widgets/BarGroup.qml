import QtQuick
import QtQuick.Layouts

RowLayout {
    id: barGroup

    required property string sidebarTitle
    required property real screenHeight
    required property real screenWidth
    property var sidebarComponents: []
    property alias sidebar: sidebarContainer

    signal sidebarToggleRequested

    onSidebarToggleRequested: toggleSidebar()

    SidebarContainer {
        id: sidebarContainer
        sidebarTitle: barGroup.sidebarTitle
        screenHeight: barGroup.screenHeight
        screenWidth: barGroup.screenWidth
        barGroup: barGroup
        visible: false
    }

    function registerSidebarComponent(component) {
        if (sidebarComponents.indexOf(component) === -1) {
            sidebarComponents.push(component);
            // Sort by priority and rebuild
            sidebarComponents.sort((a, b) => (a.sidebarPriority || 0) - (b.sidebarPriority || 0));
            sidebarContainer.rebuildContent();
        }
    }

    function unregisterSidebarComponent(component) {
        const index = sidebarComponents.indexOf(component);
        if (index > -1) {
            sidebarComponents.splice(index, 1);
            sidebarContainer.rebuildContent();
        }
    }

    function toggleSidebar() {
        sidebarContainer.visible = !sidebarContainer.visible;
    }

    function showSidebar() {
        sidebarContainer.visible = true;
    }

    function hideSidebar() {
        sidebarContainer.visible = false;
    }

    onChildrenChanged: {
        sidebarComponents = [];
        for (let i = 0; i < children.length; i++) {
            let child = children[i];
            if (child.sidebarComponent !== undefined) {
                registerSidebarComponent(child);
            }
        }
    }
}
