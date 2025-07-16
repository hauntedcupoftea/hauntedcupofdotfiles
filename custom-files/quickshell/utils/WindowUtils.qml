pragma ComponentBehavior: Bound
import QtQuick

QtObject {
    id: utils

    readonly property int maxTitleLength: 20
    readonly property int minMeaningfulTitleLength: 3
    readonly property int ellipsisLength: 1
    readonly property int maxLengthBeforeEllipsis: maxTitleLength - ellipsisLength

    // Text constants
    readonly property string ellipsisChar: "…"
    readonly property string desktopTitle: "Desktop"
    readonly property string unknownTitle: "Unknown"
    readonly property string steamIcon: "󰺷"
    readonly property string emptyIcon: ""
    readonly property string unknownIcon: ""

    // Application name mappings
    readonly property var appNameMappings: ({
            "Mozilla Firefox": "Firefox",
            "Google Chrome": "Chrome",
            "Google Chrome Beta": "Chrome Beta",
            "Google Chrome Dev": "Chrome Dev",
            "Chromium": "Chromium",
            "Visual Studio Code": "VS Code",
            "Visual Studio Code - Insiders": "VS Code Insiders",
            "LibreOffice Writer": "Writer",
            "LibreOffice Calc": "Calc",
            "LibreOffice Impress": "Impress",
            "LibreOffice Draw": "Draw",
            "LibreOffice Base": "Base",
            "LibreOffice Math": "Math",
            "GIMP": "GIMP",
            "GNU Image Manipulation Program": "GIMP",
            "Blender": "Blender",
            "OBS Studio": "OBS",
            "Discord": "Discord",
            "Slack": "Slack",
            "Telegram": "Telegram",
            "Signal": "Signal",
            "Spotify": "Spotify",
            "Spotify Premium": "Spotify",
            "VLC media player": "VLC",
            "Mozilla Thunderbird": "Thunderbird"
        })

    readonly property var steamKeywords: ["steam", "steamgame", "steamapp"]
    readonly property var exeKeywords: [".exe", "wine", "proton"]

    function formatTitle(title) {
        if (!title)
            return emptyIcon;

        let formatted = title.trim();

        if (appNameMappings[formatted]) {
            return appNameMappings[formatted];
        }

        // Special case for Zellij: extract path after second dash
        const zellijMatch = formatted.match(/^Zellij\s*\([^)]+\)\s*-\s*(.+)$/);
        if (zellijMatch) {
            return zellijMatch[1].trim();
        }

        formatted = formatted.replace(/\s*-\s*.*$/, "") // Remove everything after " - "
        .replace(/\s*—\s*.*$/, "")                      // Remove everything after " — "
        .replace(/\s*\|\s*.*$/, "")                     // Remove everything after " | "
        .replace(/\s*\(\d+\)$/, "")                     // Remove trailing numbers in parentheses
        .replace(/\.exe$/i, "")                         // Remove .exe extension
        .replace(/\s*\[.*\]$/, "")                      // Remove content in square brackets
        .replace(/\s*\{.*\}$/, "")                      // Remove content in curly brackets
        .trim();

        const lowerFormatted = formatted.toLowerCase();

        for (let keyword of steamKeywords) {
            if (lowerFormatted.includes(keyword)) {
                formatted = "Steam";
                break;
            }
        }

        // If still empty or too generic, return as-is
        if (formatted.length === 0) {
            return title.trim();
        }

        formatted = formatted.split(' ').map(word => {
            if (word.length === 0)
                return word;
            return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
        }).join(' ');

        return formatted;
    }

    /**
     * Truncates text to specified maximum length with ellipsis
     * @param text - Text to truncate
     * @param maxLength - Maximum allowed length (defaults to maxTitleLength)
     * @returns Truncated text with ellipsis if needed
     */
    function truncateText(text, maxLength) {
        const targetLength = maxLength || maxTitleLength;
        if (!text || text.length <= targetLength)
            return text;
        return text.substring(0, targetLength - ellipsisLength) + ellipsisChar;
    }

    /**
     * Gets a formatted window title from toplevel object
     * @param toplevel - The toplevel window object
     * @param showDesktop - Whether to show desktop when no window
     * @returns Formatted window title
     */
    function getWindowTitle(toplevel, showDesktop) {
        if (showDesktop || !toplevel) {
            return desktopTitle;
        }

        // Try to get a nice title from the window title first
        let title = toplevel.title;
        if (title) {
            title = formatTitle(title);
            if (title.length > minMeaningfulTitleLength) {
                return truncateText(title, maxTitleLength);
            }
        }

        // Fall back to formatted appId
        if (toplevel.appId) {
            title = formatTitle(toplevel.appId);
            return truncateText(title, maxTitleLength);
        }

        return unknownTitle;
    }

    function shouldShowSteamIcon(toplevel) {
        if (!toplevel)
            return false;

        const title = toplevel.title ? toplevel.title.toLowerCase() : "";
        const appId = toplevel.appId ? toplevel.appId.toLowerCase() : "";

        // Check steam keywords
        for (let keyword of steamKeywords) {
            if (title.includes(keyword) || appId.includes(keyword)) {
                return true;
            }
        }

        // Check exe keywords
        for (let keyword of exeKeywords) {
            if (title.includes(keyword) || appId.includes(keyword)) {
                return true;
            }
        }

        return false;
    }

    function getIconText(toplevel, windowTitle) {
        if (windowTitle === desktopTitle) {
            return emptyIcon;
        }

        if (shouldShowSteamIcon(toplevel)) {
            return steamIcon;
        }

        return unknownIcon;
    }
}
