{...}: {
  imports = [
    ./hardware-configuration.nix
    # ./netbird-testing.nix
    ../../modules/core
    ../../modules/hardware
    ../../modules/desktop
    ../../modules/theme
    ../../modules/profiles
    ../../users
    ../../modules/desktop/teamviewer.nix
  ];

  networking.hostName = "Anand-GE66-Raider";

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  dotfiles = {
    desktop = {
      enable = true;
      environments = ["hyprland"];
      gaming.enable = true;
      audio.enable = true;
      monitors = [
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = 240;
          position = "0x0";
          hdr = true;
          scale = 1;
          vrr = false;
          primary = true;
        }
      ];
    };
    services = {
      enable = true;
      podman.enable = true;
    };
  };

  system.stateVersion = "24.11";
}
