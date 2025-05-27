{ ...
}: {
  # Enable networking
  networking = {
    networkmanager.enable = true;
    # enableIPv6 = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # boot.kernel.sysctl = {
  #   "net.ipv6.conf.all.accept_ra" = 2;
  #   "net.ipv6.conf.default.accept_ra" = 2;
  # };

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
