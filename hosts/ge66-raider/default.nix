{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/hardware
    ../../modules/desktop
    ../../modules/theme
    ../../modules/profiles
    ../../users
  ];

  networking.hostName = "Anand-GE66-Raider";

  dotfiles = {
    desktop = {
      enable = true;
      environment = ["hyprland"];
      gaming.enable = true;
      audio.enable = true;
      monitors = [
        {
          name = "DP-2";
          resolution = "2560x1440";
          refreshRate = 165;
          position = "0x0";
          scale = 1;
          vrr = true;
          primary = true;
        }
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = 240;
          position = "2560x360";
          scale = 1;
          vrr = false;
          primary = false;
        }
      ];
    };

    podman.enable = true;
  };

  system.stateVersion = "24.11";
}
