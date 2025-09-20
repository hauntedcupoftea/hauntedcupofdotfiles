{lib, ...}: {
  # Enable networking
  networking = {
    # Enables DHCP on each Ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
    # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
    # enableIPv6 = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # boot.kernel.sysctl = {
  #   "net.ipv6.conf.all.accept_ra" = 2;
  #   "net.ipv6.conf.default.accept_ra" = 2;
  # };

  # This will let us install better wifi drivers supposedly
  hardware.enableRedistributableFirmware = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # turns on bluetooth controllers on boot
    settings = {
      General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
