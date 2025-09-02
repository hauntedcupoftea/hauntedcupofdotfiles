import QtQuick
import Quickshell.Io
import qs.config

QtObject {
    id: root

    readonly property string _polarityString: Settings.polarity

    property var themeView: {
        "colors": {
            "background": {
                "dark": "1a1a1a",
                "light": "ffffff",
                "default": "1a1a1a"
            },
            "error": {
                "dark": "ff6b6b",
                "light": "d32f2f",
                "default": "ff6b6b"
            },
            "error_container": {
                "dark": "4a0000",
                "light": "ffebee",
                "default": "4a0000"
            },
            "inverse_on_surface": {
                "dark": "f5f5f5",
                "light": "212121",
                "default": "f5f5f5"
            },
            "inverse_primary": {
                "dark": "3f51b5",
                "light": "c5cae9",
                "default": "3f51b5"
            },
            "inverse_surface": {
                "dark": "f5f5f5",
                "light": "212121",
                "default": "f5f5f5"
            },
            "on_background": {
                "dark": "e0e0e0",
                "light": "212121",
                "default": "e0e0e0"
            },
            "on_error": {
                "dark": "000000",
                "light": "ffffff",
                "default": "000000"
            },
            "on_error_container": {
                "dark": "ffcdd2",
                "light": "b71c1c",
                "default": "ffcdd2"
            },
            "on_primary": {
                "dark": "ffffff",
                "light": "ffffff",
                "default": "ffffff"
            },
            "on_primary_container": {
                "dark": "e8eaf6",
                "light": "1a237e",
                "default": "e8eaf6"
            },
            "on_primary_fixed": {
                "dark": "1a237e",
                "light": "1a237e",
                "default": "1a237e"
            },
            "on_primary_fixed_variant": {
                "dark": "303f9f",
                "light": "303f9f",
                "default": "303f9f"
            },
            "on_secondary": {
                "dark": "ffffff",
                "light": "ffffff",
                "default": "ffffff"
            },
            "on_secondary_container": {
                "dark": "f3e5f5",
                "light": "4a148c",
                "default": "f3e5f5"
            },
            "on_secondary_fixed": {
                "dark": "4a148c",
                "light": "4a148c",
                "default": "4a148c"
            },
            "on_secondary_fixed_variant": {
                "dark": "7b1fa2",
                "light": "7b1fa2",
                "default": "7b1fa2"
            },
            "on_surface": {
                "dark": "e0e0e0",
                "light": "212121",
                "default": "e0e0e0"
            },
            "on_surface_variant": {
                "dark": "bdbdbd",
                "light": "616161",
                "default": "bdbdbd"
            },
            "on_tertiary": {
                "dark": "ffffff",
                "light": "ffffff",
                "default": "ffffff"
            },
            "on_tertiary_container": {
                "dark": "fce4ec",
                "light": "880e4f",
                "default": "fce4ec"
            },
            "on_tertiary_fixed": {
                "dark": "880e4f",
                "light": "880e4f",
                "default": "880e4f"
            },
            "on_tertiary_fixed_variant": {
                "dark": "ad1457",
                "light": "ad1457",
                "default": "ad1457"
            },
            "outline": {
                "dark": "757575",
                "light": "9e9e9e",
                "default": "757575"
            },
            "outline_variant": {
                "dark": "424242",
                "light": "e0e0e0",
                "default": "424242"
            },
            "primary": {
                "dark": "7986cb",
                "light": "3f51b5",
                "default": "7986cb"
            },
            "primary_container": {
                "dark": "303f9f",
                "light": "e8eaf6",
                "default": "303f9f"
            },
            "primary_fixed": {
                "dark": "e8eaf6",
                "light": "e8eaf6",
                "default": "e8eaf6"
            },
            "primary_fixed_dim": {
                "dark": "7986cb",
                "light": "7986cb",
                "default": "7986cb"
            },
            "scrim": {
                "dark": "000000",
                "light": "000000",
                "default": "000000"
            },
            "secondary": {
                "dark": "ba68c8",
                "light": "9c27b0",
                "default": "ba68c8"
            },
            "secondary_container": {
                "dark": "7b1fa2",
                "light": "f3e5f5",
                "default": "7b1fa2"
            },
            "secondary_fixed": {
                "dark": "f3e5f5",
                "light": "f3e5f5",
                "default": "f3e5f5"
            },
            "secondary_fixed_dim": {
                "dark": "ba68c8",
                "light": "ba68c8",
                "default": "ba68c8"
            },
            "shadow": {
                "dark": "000000",
                "light": "000000",
                "default": "000000"
            },
            "surface": {
                "dark": "1a1a1a",
                "light": "ffffff",
                "default": "1a1a1a"
            },
            "surface_bright": {
                "dark": "2a2a2a",
                "light": "ffffff",
                "default": "2a2a2a"
            },
            "surface_container": {
                "dark": "1e1e1e",
                "light": "f5f5f5",
                "default": "1e1e1e"
            },
            "surface_container_high": {
                "dark": "242424",
                "light": "eeeeee",
                "default": "242424"
            },
            "surface_container_highest": {
                "dark": "2a2a2a",
                "light": "e8e8e8",
                "default": "2a2a2a"
            },
            "surface_container_low": {
                "dark": "181818",
                "light": "fafafa",
                "default": "181818"
            },
            "surface_container_lowest": {
                "dark": "121212",
                "light": "ffffff",
                "default": "121212"
            },
            "surface_dim": {
                "dark": "1a1a1a",
                "light": "e0e0e0",
                "default": "1a1a1a"
            },
            "surface_tint": {
                "dark": "7986cb",
                "light": "3f51b5",
                "default": "7986cb"
            },
            "surface_variant": {
                "dark": "424242",
                "light": "f5f5f5",
                "default": "424242"
            },
            "tertiary": {
                "dark": "f48fb1",
                "light": "e91e63",
                "default": "f48fb1"
            },
            "tertiary_container": {
                "dark": "ad1457",
                "light": "fce4ec",
                "default": "ad1457"
            },
            "tertiary_fixed": {
                "dark": "fce4ec",
                "light": "fce4ec",
                "default": "fce4ec"
            },
            "tertiary_fixed_dim": {
                "dark": "f48fb1",
                "light": "f48fb1",
                "default": "f48fb1"
            }
        },
        "is_dark_mode": true,
        "mode": "Dark"
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
