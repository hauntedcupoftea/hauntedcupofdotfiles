import QtQuick
import QtQuick.Layouts

RowLayout {
    id: exclusiveLayout
    property var menuItems: []

    function registerMenu(menuItem) {
        if (menuItems.indexOf(menuItem) === -1) {
            menuItems.push(menuItem);
            if (menuItem.requestOpen) {
                menuItem.requestOpen.connect(() => openMenu(menuItem));
            }
        }
    }

    function openMenu(targetMenu) {
        // Close all menus first
        for (let i = 0; i < menuItems.length; i++) {
            let menu = menuItems[i];
            if (menu !== targetMenu && menu.forceClose) {
                menu.forceClose();
            }
        }
    }

    // Function to close all menus
    function closeAllMenus() {
        for (let i = 0; i < menuItems.length; i++) {
            let menu = menuItems[i];
            if (menu.forceClose) {
                menu.forceClose();
            }
        }
    }

    // Auto-register children when they're added
    onChildrenChanged: {
        for (let i = 0; i < children.length; i++) {
            let child = children[i];
            // Check if this child has menu-like properties
            if (child.requestOpen !== undefined && child.forceClose !== undefined) {
                registerMenu(child);
            }
        }
    }
}
