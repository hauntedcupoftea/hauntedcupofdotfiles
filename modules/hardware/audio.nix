{ ...
}: {
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # You have this commented, which is fine

    # Add WirePlumber extra configuration here
    wireplumber.extraConfig."51-disable-mic-agc" = {
      # This section targets ALSA audio devices (your microphone)
      "monitor.alsa.rules" = [
        {
          # This matches all ALSA input devices (microphones)
          matches = [{ "node.name" = "~alsa_input.*"; }];
          actions = {
            "update-props" = {
              "webrtc.audio.processing" = {
                "automatic_gain_control" = false; # Disable Automatic Gain Control

                # By default, WirePlumber might also enable other features like
                # echo cancellation and noise suppression. If you want to keep those,
                # you might need to explicitly enable them here.
                # If you only want to disable AGC and let other defaults apply,
                # this might be enough. However, to be certain about other settings:
                # "echo_cancellation" = true;      # Example: keep echo cancellation
                # "noise_suppression" = true;    # Example: keep noise suppression
                # "voice_activity_detection" = true; # Example: keep VAD
              };
            };
          };
        }
      ];
    };

    # It's also good practice to ensure PipeWire's PulseAudio emulation
    # isn't trying to do something like flat volumes, though this is less likely the cause.
    # PipeWire's PulseAudio server generally defaults to non-flat volumes.
    extraConfig.pipewire-pulse."99-pulse-settings" = {
      "context.properties" = {
        "pulse.flat.volume" = false; # Explicitly set, though often default in PipeWire
      };
    };
  };
}
