{...}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  # security.pam.services.hyprlock = {};
  services.xserver.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
