{...}: {
  services.displayManager.cosmic-greeter.enable = true;
  security.pam.services.cosmic-greeter.gaze = {
    enable = true;
    simultaneous = true;
  };
}
