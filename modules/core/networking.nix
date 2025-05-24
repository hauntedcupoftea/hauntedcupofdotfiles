{ ...
}: {
  # Enable networking
  networking = {
    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

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
