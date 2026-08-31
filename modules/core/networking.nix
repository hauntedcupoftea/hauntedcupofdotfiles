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

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      enable = true;
      allowedTCPPorts = [6600]; # for MPD
    };

    wireless.iwd = {
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
