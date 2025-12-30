{inputs, ...}: {
  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    # this might be causing crackling
    # lowLatency = {
    #   enable = true;
    # };

    wireplumber.extraConfig."51-disable-mic-agc" = {
      "monitor.alsa.rules" = [
        {
          matches = [{"node.name" = "~alsa_input.*";}];
          actions = {
            "update-props" = {
              "webrtc.audio.processing" = {
                "automatic_gain_control" = false; # Disable Automatic Gain Control
              };
            };
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."99-pulse-settings" = {
      "context.properties" = {
        "pulse.flat.volume" = false;
      };
    };
  };
}
