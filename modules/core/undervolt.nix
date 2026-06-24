{...}: {
  services.undervolt = {
    enable = true;
    coreOffset = -45;
    gpuOffset = -25;
    uncoreOffset = -25;
    analogioOffset = 0;
  };

  programs.tuxclocker = {
    enable = false;
    useUnfree = true;
    enabledNVIDIADevices = true;
  };
}
