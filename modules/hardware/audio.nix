{inputs, ...}: {
  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # might cause crackling
    lowLatency.enable = true;

    wireplumber.extraConfig."51-block-source-volume" = {
      "pulse.rules" = [
        {
          matches = [
            {application.process.binary = "firefox";}
            {application.process.binary = "chrome";}
            {application.process.binary = "Discord";}
          ];
          actions.quirks = ["block-source-volume"];
        }
      ];
    };

    extraConfig.pipewire-pulse."99-pulse-settings" = {
      "context.properties"."pulse.flat.volume" = false;
    };
  };
}
