import QtQuick
import QtQuick.Controls

import qs.theme
import qs.components.internal as Private

Item {
    id: barButton

    property bool menuOpen: false
    property alias text: mainText.text
    property alias textColor: mainText.color
    property color hoverColor: Theme.colors.surface0
    property color defaultColor: Theme.colors.crust
    property color pressedColor: Theme.colors.mauve

    property alias isMenuOpen: barButton.menuOpen
    property alias button: toggleButton

    default property alias content: contentHost.data

    signal requestOpen

    function forceClose() {
        menuOpen = false;
    }

    implicitWidth: mainText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    Action {
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

    Button {
        id: toggleButton
        anchors.fill: parent
        action: toggleMenuAction

        background: Rectangle {
            id: buttonBackground
            radius: Theme.rounding.verysmall
            color: toggleButton.hovered ? barButton.hoverColor : barButton.defaultColor

            states: State {
                name: "pressed"
                when: toggleButton.pressed || barButton.menuOpen
                PropertyChanges {
                    mainText.color: barButton.pressedColor
                }
            }

            transitions: Transition {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        Private.StyledText {
            id: mainText
            anchors.centerIn: parent
            font.pixelSize: Theme.font.larger
            font.weight: 500
        }
    }

    Item {
        id: contentHost
        anchors.fill: parent
    }
}
