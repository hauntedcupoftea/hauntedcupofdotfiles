import QtQuick
import QtQuick.Controls
import Quickshell

import qs.widgets
import qs.theme
import qs.services
import "internal" as Private

AbstractBarButton {
    id: root
    sidebarComponent: Private.SessionMenuPopout {}

    implicitWidth: osText.implicitWidth + (Theme.padding * 2)
    implicitHeight: Theme.barHeight - (Theme.margin)

    property real systemActivity: UsageMetrics.systemActivity

    background: Rectangle {
        id: bg
        color: root.hovered ? Theme.colors.surface_container_highest : Theme.colors.surface_container
        radius: Theme.rounding.small
    }

    Heartbeat {
        id: osText
        anchors.centerIn: parent

        systemActivity: root.systemActivity
        text: "" // Your Linux logo

        color: Theme.colors.secondary
        font.pixelSize: Theme.font.large
        font.weight: 500
    }

    action: Action {
        onTriggered: {
            print("im triggered");
            Quickshell.execDetached([Quickshell.env("TERM")]);
        }
    }

    Private.ToolTipPopup {
        targetWidget: root
        triggerTarget: true
        position: Qt.rect(Theme.padding, root.height + Theme.padding, 0, 0)
        expandDirection: Edges.Bottom | Edges.Right
        blockShow: root.menuOpen

        Private.StyledText {
            textFormat: Text.RichText

            readonly property color iconColor: Theme.colors.on_surface_variant
            readonly property color valueColor: Theme.colors.on_surface

            text: {
                let cpu_icon = `<font color='${iconColor}'></font>`;
                let ram_icon = `<font color='${iconColor}'></font>`;
                let gpu_icon = `<font color='${iconColor}'>󰍹</font>`;
                let storage_icon = `<font color='${iconColor}'></font>`;

                let cpu_line = `${cpu_icon} <font color='${valueColor}'>${(UsageMetrics.cpuPerc * 100).toFixed(0)}% at ${UsageMetrics.cpuTemp}°C</font>`;

                let ram_used = UsageMetrics.formatKib(UsageMetrics.memUsed);
                let ram_total = UsageMetrics.formatKib(UsageMetrics.memTotal);
                let ram_line = `${ram_icon} <font color='${valueColor}'>${ram_used.value.toFixed(1)} / ${ram_total.value.toFixed(1)} ${ram_total.unit}</font>`;

                let storage_used = UsageMetrics.formatKib(UsageMetrics.storageUsed);
                let storage_total = UsageMetrics.formatKib(UsageMetrics.storageTotal);
                let storage_line = `${storage_icon} <font color='${valueColor}'>${storage_used.value.toFixed(1)} ${storage_used.unit} / ${storage_total.value.toFixed(1)} ${storage_total.unit}</font>`;

                return `${cpu_line}<br>${ram_line}<br>${storage_line}`;
            }
        }
    }

    Component.onCompleted: {
        UsageMetrics.refCount++;
    }

    Component.onDestruction: {
        UsageMetrics.refCount--;
    }
}
