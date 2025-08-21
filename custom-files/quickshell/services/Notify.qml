pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
// import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

import qs.services

Singleton {
    id: root

    property list<Notification> popups: []

    property list<Notification> centerItems: []

    // Configuration
    readonly property int maxPopups: 5
    readonly property int maxCenterItems: 100
    readonly property int defaultTimeout: 8000 // 8 seconds

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
            print("caught one!");
            root.centerItems.forEach(e => {
                print(e.body);
            });
            // print(JSON.stringify(notification));
            // Track the notification for proper lifecycle
            notification.tracked = true;

            // Always add to notification center
            const centerItem = root.createNotificationItem(notification, false);

            // Also show as popup unless suppressed
            // if (!Settings.data?.notifications?.suppressed) { // TODO: add this lol
            root.createNotificationItem(notification, true, centerItem);
        // }
        }
    }

    function createNotificationItem(notification, isPopup, linkedCenterItem = null) {
        if (isPopup) {
            // Add to front of popups
            root.popups.unshift(notification);

            // Remove oldest popups if we exceed max
            while (root.popups.length > maxPopups) {
                const oldest = root.popups.pop();
                oldest.destroy();
            }
        } else {
            // Add to front of center items (most recent first)
            root.centerItems.unshift(notification);

            // Trim excess items
            while (root.centerItems.length > maxCenterItems) {
                const oldest = root.centerItems.pop();
                oldest.destroy();
            }
        }
    }

    function dismissPopup(popup) {
        const index = root.popups.indexOf(popup);
        if (index !== -1) {
            root.popups.splice(index, 1);
            popup.destroy();
        }
    }

    function dismissAllPopups() {
        for (const popup of [...root.popups]) {
            dismissPopup(popup);
        }
    }

    function removeCenterItem(item) {
        const index = root.centerItems.indexOf(item);
        if (index !== -1) {
            root.centerItems.splice(index, 1);

            if (item.notification && item.notification.dismiss) {
                item.notification.dismiss();
            }

            item.destroy();
        }
    }

    function clearNotificationCenter() {
        for (const item of [...root.centerItems]) {
            removeCenterItem(item);
        }
    }

    function clearAll() {
        dismissAllPopups();
        clearNotificationCenter();
    }

    function formatTimeAgo(timestamp) {
        if (!timestamp)
            return "";

        const diff = Time.rawtime - timestamp.getTime();

        if (diff < 60000) {
            // < 1 minute
            return "now";
        } else if (diff < 3600000) {
            // < 1 hour
            const minutes = Math.floor(diff / 60000);
            return `${minutes}m`;
        } else if (diff < 86400000) {
            // < 24 hours
            const hours = Math.floor(diff / 3600000);
            return `${hours}h`;
        } else {
            // >= 24 hours
            const days = Math.floor(diff / 86400000);
            return `${days}d`;
        }
    }
}
