{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/hardware/audio.nix
    ../../modules/hardware/razer.nix
    ../../modules/hardware/power.nix
    ../../modules/desktop
    ../../modules/theme
    ../../modules/profiles
    ../../users
  ];

  ## AMDGPU config
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu = {
    initrd.enable = true;
    overdrive.enable = true;
  };

  environment.systemPackages = with pkgs; [lact];
  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  services.xserver.videoDrivers = ["amdgpu"];
  ## end AMDGPU config

  networking.hostName = "9770xt";

  dotfiles = {
    desktop = {
      enable = true;
      environment = ["hyprland"];
      gaming.enable = true;
      audio.enable = true;
      monitors = [
        {
          name = "HDMI-A-1";
          resolution = "2560x1440";
          refreshRate = 165;
          position = "0x0";
          scale = 1;
          vrr = true;
          primary = true;
        }
      ];
    };
    services = {
      enable = true;
      podman.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
