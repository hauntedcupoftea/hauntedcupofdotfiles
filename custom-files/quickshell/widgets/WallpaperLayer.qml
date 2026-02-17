pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services
import qs.theme

// https://github.com/Rexcrazy804/Zaphkiel/blob/master/dots/quickshell/kurukurubar/Layers/Wallpaper.qml
// thanks, rexi
WlrLayershell {
    id: layerRoot

    required property ShellScreen modelData

    screen: modelData
    layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    color: "transparent"
    surfaceFormat.opaque: false

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    namespace: "hauntedcupof.wallpaper"

    Image {
        id: currentImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        antialiasing: true
        asynchronous: true
        retainWhileLoading: true
        source: Wallpaper.current !== "" ? Qt.url(Wallpaper.current) : ""
    }

    Image {
        id: incomingImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        antialiasing: true
        asynchronous: true
        retainWhileLoading: true
        visible: false
        source: ""
    }

    Rectangle {
        id: wipeRect
        color: "transparent"
        clip: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 0

        Image {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: layerRoot.width
            fillMode: Image.PreserveAspectCrop
            smooth: true
            antialiasing: true
            source: incomingImage.source
        }

        NumberAnimation {
            id: wipeAnim
            target: wipeRect
            property: "width"
            from: 0
            to: layerRoot.width
            duration: Theme.anims.curve.expressiveFastSpatialDuration * 5  // ~1750ms
            easing.bezierCurve: Theme.anims.curve.expressiveFastSpatial

            onFinished: {
                currentImage.source = incomingImage.source;
                incomingImage.source = "";
                wipeRect.width = 0;
            }
        }
    }

    Connections {
        target: Wallpaper
        function onCurrentChanged() {
            const next = Wallpaper.current;
            if (!next || next === "")
                return;
            if (wipeAnim.running)
                wipeAnim.complete();
            incomingImage.source = Qt.url(next);
        }
    }

    Connections {
        target: incomingImage
        function onStatusChanged() {
            if (incomingImage.status === Image.Ready)
                wipeAnim.start();
            if (incomingImage.status === Image.Error) {
                console.warn("[WallpaperLayer] Failed to load: " + incomingImage.source);
                incomingImage.source = "";
            }
        }
    }
}
