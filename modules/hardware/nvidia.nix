{ config
, ...
}: {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Power management settings
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Using proprietary driver
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Use stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
