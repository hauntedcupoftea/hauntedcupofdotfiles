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

    onReadyChanged: print(`[Audio] Pipewire ready=${audio.ready}`)

    onDefaultOutputChanged: {
        if (audio.defaultOutput)
            print(`[Audio] default output: ${audio.defaultOutput.name} vol=${Math.round(audio.defaultOutput.audio?.volume * 100)}% mute=${audio.defaultOutput.audio?.muted}`);
    }

    onDefaultInputChanged: {
        if (audio.defaultInput)
            print(`[Audio] default input: ${audio.defaultInput.name}`);
    }

    function changeOutputVolume(volume: real) {
        if (defaultOutput?.ready && defaultOutput?.audio) {
            defaultOutput.audio.muted = false;
            const newVol = Math.max(0, Math.min(1, defaultOutput.audio.volume + volume));
            defaultOutput.audio.volume = newVol;
            print(`[Audio] output volume: ${Math.round(newVol * 100)}%`);
        }
    }

    function toggleOutputMute() {
        if (defaultOutput?.ready && defaultOutput?.audio) {
            defaultOutput.audio.muted = !defaultOutput.audio.muted;
            print(`[Audio] output mute: ${defaultOutput.audio.muted}`);
        }
    }

    function changeInputVolume(volume: real) {
        if (defaultInput?.ready && defaultInput?.audio) {
            defaultInput.audio.muted = false;
            const newVol = Math.max(0, Math.min(1, defaultInput.audio.volume + volume));
            defaultInput.audio.volume = newVol;
            print(`[Audio] input volume: ${Math.round(newVol * 100)}%`);
        }
    }

    function toggleInputMute() {
        if (defaultInput?.ready && defaultInput?.audio) {
            defaultInput.audio.muted = !defaultInput.audio.muted;
            print(`[Audio] input mute: ${defaultInput.audio.muted}`);
        }
    }

    PwObjectTracker {
        objects: [audio.defaultOutput, audio.defaultInput]
    }
}
