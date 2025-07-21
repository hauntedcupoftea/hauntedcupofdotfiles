pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: audio

    property bool ready: Pipewire.ready

    property PwNode defaultOutput: Pipewire.defaultAudioSink
    property PwNode defaultInput: Pipewire.defaultAudioSource
    property list<PwNode> outputList: Pipewire.nodes.values.filter(n => n.isSink)
    property list<PwNode> inputList: Pipewire.nodes.values.filter(n => !n.isSink)
    // TODO: add channel list for applications (volume mixer)

    function setOutputVolume(volume: real) {
        if (defaultOutput?.ready && defaultOutput?.audio) {
            defaultOutput.audio.muted = false;
            defaultOutput.audio.volume = volume;
        }
    }

    function toggleOutputMute() {
        if (defaultOutput?.ready && defaultOutput?.audio)
            defaultOutput.audio.muted = !defaultOutput.audio.muted;
    }

    function setInputVolume(volume: real) {
        if (defaultInput?.ready && defaultInput?.audio) {
            defaultInput.audio.muted = false;
            defaultInput.audio.volume = volume;
        }
    }

    function toggleInputMute() {
        if (defaultInput?.ready && defaultInput?.audio)
            defaultInput.audio.muted = !defaultInput.audio.muted;
    }

    PwObjectTracker {
        objects: [audio.defaultOutput, audio.defaultInput]
    }
}
