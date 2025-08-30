import QtQuick
import Quickshell.Io
import "../config"

QtObject {
    id: root

    readonly property string _polarityString: Settings.polarity

    property var themeView: {
        "colors": {
            "dark": {},
            "light": {}
        }
    }

    readonly property FileView themeFile: FileView {
        id: fileView
        path: "/home/tea/.config/matugen/theme.json"
        watchChanges: true
        onFileChanged: fileView.reload()
        onLoaded: {
            try {
                root.themeView = JSON.parse(text());
            } catch (e) {
                console.error("Failed to parse theme.json:", e);
            }
        }
        Component.onCompleted: fileView.reload()
    }

    function getColor(name, fallbackColor = "#000000") {
        const colorValue = themeView?.colors?.[name].default;
        return Qt.color(colorValue ? "#" + colorValue : fallbackColor);
    }

    readonly property color background: getColor("background")
    readonly property color error: getColor("error", "#ff0000")
    readonly property color error_container: getColor("error_container")
    readonly property color inverse_on_surface: getColor("inverse_on_surface")
    readonly property color inverse_primary: getColor("inverse_primary")
    readonly property color inverse_surface: getColor("inverse_surface")
    readonly property color on_background: getColor("on_background")
    readonly property color on_error: getColor("on_error")
    readonly property color on_error_container: getColor("on_error_container")
    readonly property color on_primary: getColor("on_primary")
    readonly property color on_primary_container: getColor("on_primary_container")
    readonly property color on_primary_fixed: getColor("on_primary_fixed")
    readonly property color on_primary_fixed_variant: getColor("on_primary_fixed_variant")
    readonly property color on_secondary: getColor("on_secondary")
    readonly property color on_secondary_container: getColor("on_secondary_container")
    readonly property color on_secondary_fixed: getColor("on_secondary_fixed")
    readonly property color on_secondary_fixed_variant: getColor("on_secondary_fixed_variant")
    readonly property color on_surface: getColor("on_surface")
    readonly property color on_surface_variant: getColor("on_surface_variant")
    readonly property color on_tertiary: getColor("on_tertiary")
    readonly property color on_tertiary_container: getColor("on_tertiary_container")
    readonly property color on_tertiary_fixed: getColor("on_tertiary_fixed")
    readonly property color on_tertiary_fixed_variant: getColor("on_tertiary_fixed_variant")
    readonly property color outline: getColor("outline")
    readonly property color outline_variant: getColor("outline_variant")
    readonly property color primary: getColor("primary")
    readonly property color primary_container: getColor("primary_container")
    readonly property color primary_fixed: getColor("primary_fixed")
    readonly property color primary_fixed_dim: getColor("primary_fixed_dim")
    readonly property color scrim: getColor("scrim")
    readonly property color secondary: getColor("secondary")
    readonly property color secondary_container: getColor("secondary_container")
    readonly property color secondary_fixed: getColor("secondary_fixed")
    readonly property color secondary_fixed_dim: getColor("secondary_fixed_dim")
    readonly property color shadow: getColor("shadow")
    readonly property color surface: getColor("surface")
    readonly property color surface_bright: getColor("surface_bright")
    readonly property color surface_container: getColor("surface_container")
    readonly property color surface_container_high: getColor("surface_container_high")
    readonly property color surface_container_highest: getColor("surface_container_highest")
    readonly property color surface_container_low: getColor("surface_container_low")
    readonly property color surface_container_lowest: getColor("surface_container_lowest")
    readonly property color surface_dim: getColor("surface_dim")
    readonly property color surface_tint: getColor("surface_tint")
    readonly property color surface_variant: getColor("surface_variant")
    readonly property color tertiary: getColor("tertiary")
    readonly property color tertiary_container: getColor("tertiary_container")
    readonly property color tertiary_fixed: getColor("tertiary_fixed")
    readonly property color tertiary_fixed_dim: getColor("tertiary_fixed_dim")
}
