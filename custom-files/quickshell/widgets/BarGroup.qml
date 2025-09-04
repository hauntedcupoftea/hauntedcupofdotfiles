import QtQuick
import QtQuick.Layouts

Item {
    id: barGroup
    implicitHeight: rowLayout.height
    implicitWidth: rowLayout.width

    required property string sidebarTitle
    required property real screenHeight
    required property real screenWidth
    required property real widthRatio
    required property real heightRatio
    property var gravity
    property rect position
    property list<string> sidebarComponents: []
    property alias sidebar: sidebarContainer
    property alias spacing: rowLayout.spacing

    default property alias data: rowLayout.data

    signal sidebarToggleRequested

    onSidebarToggleRequested: toggleSidebar()

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
    }

    SidebarContainer {
        id: sidebarContainer
        anchorItem: barGroup
        gravity: barGroup.gravity
        position: barGroup.position
        widthRatio: barGroup.widthRatio
        heightRatio: barGroup.heightRatio
        sidebarTitle: barGroup.sidebarTitle
        screenHeight: barGroup.screenHeight
        screenWidth: barGroup.screenWidth
        barGroup: barGroup
        visible: false
    }

    function registerSidebarComponent(component) {
        if (sidebarComponents.indexOf(component) === -1) {
            sidebarComponents.push(component.sidebarComponent);
            // Sort by priority and rebuild
            sidebarComponents.sort((a, b) => (a.sidebarPriority || 0) - (b.sidebarPriority || 0));
        }
    }

    function unregisterSidebarComponent(component) {
        const index = sidebarComponents.indexOf(component);
        if (index > -1) {
            sidebarComponents.splice(index, 1);
        }
    }

    function toggleSidebar() {
        sidebarContainer.visible = !sidebarContainer.visible;
        print("toggled");
    }

    function showSidebar() {
        sidebarContainer.visible = true;
    }

    function hideSidebar() {
        sidebarContainer.visible = false;
    }

    Connections {
        target: rowLayout
        function onChildrenChanged() {
            barGroup.sidebarComponents = [];
            for (let i = 0; i < rowLayout.children.length; i++) {
                let child = rowLayout.children[i];
                if (child.sidebarComponent !== undefined) {
                    barGroup.registerSidebarComponent(child);
                }
            }
        }
    }

    Component.onCompleted: {
        for (let i = 0; i < rowLayout.children.length; i++) {
            let child = rowLayout.children[i];
            if (child.sidebarComponent !== undefined) {
                registerSidebarComponent(child);
            }
        }
    }
}
