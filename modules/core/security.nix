{...}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  # security.pam.services.hyprlock = {};
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
