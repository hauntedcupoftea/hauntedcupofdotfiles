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
        backend = "wpa_supplicant";
        powersave = false;
      };
      plugins = [pkgs.networkmanager-openvpn];
    };
    enableIPv6 = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [6600]; # for MPD
    };
  };

  hardware.enableRedistributableFirmware = true;
  boot.extraModprobeConfig = ''
    options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
    options rtw89_core disable_ps_mode=y
  '';

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
