pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

import qs.services

Singleton {
    id: root

    component NotificationItem: QtObject {
        id: notifItem

        property bool popup: false
        property Notification n: null
        property double received: new Date().getTime()
        property string receivedString: root.formatTimeAgo(received)
        readonly property string summary: n.summary
        readonly property string body: n.body
        readonly property string appIcon: n.appIcon
        readonly property string appName: n.appName
        readonly property string image: n.image
        readonly property int urgency: n.urgency
        readonly property list<NotificationAction> actions: n.actions // qmllint disable
        readonly property real timeout: {
            if (n.expireTimeout > 0)
                return n.expireTimeout;
            switch (n.urgency) {
            case NotificationUrgency.Low:
                return root.timeoutLow;
            case NotificationUrgency.Normal:
                return root.timeoutNormal;
            case NotificationUrgency.Critical:
                return root.timeoutCritical;
            }
        }

        readonly property Timer timer: Timer {
            running: notifItem.timeout > 0
            interval: notifItem.timeout
            onTriggered: {
                notifItem.popup = false;
            }
        }

        readonly property Connections conn: Connections {
            target: notifItem.n.Retainable

            function onDropped(): void {
                root.items.splice(root.items.indexOf(notifItem), 1); // remove from list
            }

            function onAboutToDestroy(): void {
                // notifItem.n.dismiss(); // this is problematic for discord notifications somehow
                notifItem.destroy();
            }
        }
    }

    property list<NotificationItem> items: []
    property list<NotificationItem> popups: items.filter(n => n.popup)

    // Configuration
    property bool doNotDisturb: false
    property bool trackLowUrgency: true
    property real timeoutLow: 5000
    property real timeoutNormal: 8000
    property real timeoutCritical: -1 // do not timeout
    property int maxPopups: 5
    property int maxCenterItems: 100

    NotificationServer {
        id: server
        keepOnReload: false

        // Server capabilities
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionIconsSupported: true
        persistenceSupported: true
        inlineReplySupported: true

        onNotification: notification => {
            notification.tracked = true;
            root.items.push(notifWrap.createObject(root, {
                popup: true,
                n: notification
            }));
        }
    }

    IpcHandler {
        target: "notify"

        function clearPopup(): void {
            for (const notif of root.items)
                notif.popup = false;
        }
        function toggleDND(): void {
            root.doNotDisturb = !root.doNotDisturb;
        }
    }

    function formatTimeAgo(timestamp: double): string {
        if (!timestamp)
            return "";

        const diff = Time.rawtime.getTime() - timestamp;

        if (diff < 1000) {
            return "now";
        } else if (diff < 60000) {
            const seconds = Math.floor(diff / 1000);
            return `${seconds}s`;
        } else if (diff < 3600000) {
            const minutes = Math.floor(diff / 60000);
            return `${minutes}m`;
        } else if (diff < 86400000) {
            const hours = Math.floor(diff / 3600000);
            return `${hours}h`;
        } else {
            const days = Math.floor(diff / 86400000);
            return `${days}d`;
        }
    }

    Component {
        id: notifWrap

        NotificationItem {}
    }
}
