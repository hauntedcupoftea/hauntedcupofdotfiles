{
  lib,
  pkgs,
  ...
}: {
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
      plugins = [pkgs.networkmanager-openvpn];
    };
    enableIPv6 = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [6600]; # for MPD
    };
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          Settings = {
            AutoConnect = true;
          };
          DriverQuirks = {
            PowerSaveDisable = "*";
          };
        };
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [overskride];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
