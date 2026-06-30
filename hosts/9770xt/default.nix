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
  boot.kernelParams = ["video=DP-3:2560x1440@60e"];
  ## end AMDGPU config

  ## hw monitoring and control
  programs.coolercontrol.enable = true;
  services.hardware.openrgb.enable = true;
  ## end hwmac

  networking.hostName = "9770xt";

  dotfiles = {
    desktop = {
      enable = true;
      environment = ["hyprland"];
      gaming.enable = true;
      audio.enable = true;
      monitors = [
        {
          name = "DP-3";
          resolution = "2560x1440";
          refreshRate = 165;
          position = "0x0";
          scale = 1;
          vrr = true;
          primary = true;
          hdr = true;
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
