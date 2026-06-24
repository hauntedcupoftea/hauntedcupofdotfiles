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

    property bool sidebarOpen: false
    readonly property bool hasSidebarContent: sidebarComponents.length > 0

    default property alias data: rowLayout.data

    signal sidebarToggleRequested

    onSidebarToggleRequested: toggleSidebar()

    onSidebarOpenChanged: {
        sidebarContainer.visible = sidebarOpen && hasSidebarContent;
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
    }

    SidebarContainer {
        id: sidebarContainer
        anchorItem: barGroup
        gravity: barGroup.gravity
        position: barGroup.position
        sidebarTitle: barGroup.sidebarTitle
        screenHeight: barGroup.screenHeight
        screenWidth: barGroup.screenWidth
        widthRatio: barGroup.widthRatio
        heightRatio: barGroup.heightRatio
        barGroup: barGroup
        visible: false

        onVisibleChanged: {
            if (!visible && barGroup.sidebarOpen) {
                barGroup.sidebarOpen = false;
            }
        }
    }

    function registerSidebarComponent(component) {
        if (!component || !component.sidebarComponent)
            return;

        if (sidebarComponents.includes(component.sidebarComponent))
            return;

        sidebarComponents.push(component.sidebarComponent);
        // Sort by priority if needed
        sidebarComponents.sort((a, b) => {
            const aPriority = a.sidebarPriority || 0;
            const bPriority = b.sidebarPriority || 0;
            return aPriority - bPriority;
        });
    }

    function unregisterSidebarComponent(component) {
        if (!component || !component.sidebarComponent)
            return;

        const index = sidebarComponents.indexOf(component.sidebarComponent);
        if (index > -1) {
            sidebarComponents.splice(index, 1);
        }
    }

    function toggleSidebar() {
        if (!hasSidebarContent) {
            console.warn("BarGroup: No sidebar content to show");
            return;
        }
        sidebarOpen = !sidebarOpen;
    }

    function showSidebar() {
        if (!hasSidebarContent) {
            console.warn("BarGroup: No sidebar content to show");
            return;
        }
        sidebarOpen = true;
    }

    function hideSidebar() {
        sidebarOpen = false;
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
