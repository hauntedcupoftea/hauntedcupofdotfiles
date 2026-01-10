pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.theme

Item {
    id: visualizer

    readonly property bool active: Network.isConnected
    readonly property int barCount: Network.historySize

    implicitWidth: 200
    implicitHeight: 40

    Row {
        id: barContainer
        anchors.fill: parent
        anchors.margins: Theme.margin / 2
        spacing: 2

        Repeater {
            model: visualizer.barCount

            Item {
                id: columnRoot
                required property int index

                width: (barContainer.width - (barContainer.spacing * (visualizer.barCount - 1))) / visualizer.barCount
                height: barContainer.height

                readonly property real rxLevel: {
                    if (!visualizer.active || index >= Network.rxHistory.length)
                        return 0.0;
                    return Math.min(Network.rxHistory[index] / Network.maxRxRate, 1.0);
                }

                readonly property real txLevel: {
                    if (!visualizer.active || index >= Network.txHistory.length)
                        return 0.0;
                    return Math.min(Network.txHistory[index] / Network.maxTxRate, 1.0);
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: 1
                    color: Qt.alpha(Theme.colors.outline, 0.2)
                }

                Rectangle {
                    id: ulBar
                    anchors.bottom: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width

                    height: Math.max(0, (parent.height / 2) * columnRoot.txLevel)

                    color: Theme.colors.tertiary
                    radius: 1

                    Behavior on height {
                        SpringAnimation {
                            spring: 3.0
                            damping: 0.4
                            mass: 0.5
                        }
                    }
                }

                Rectangle {
                    id: dlBar
                    anchors.top: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width

                    height: Math.max(0, (parent.height / 2) * columnRoot.rxLevel)

                    color: Theme.colors.primary
                    radius: 1

                    Behavior on height {
                        SpringAnimation {
                            spring: 3.0
                            damping: 0.4
                            mass: 0.5
                        }
                    }
                }
            }
        }
    }
}
