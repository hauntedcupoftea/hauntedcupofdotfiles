{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop;
in {
  config = lib.mkIf (cfg.enable && cfg.gaming.enable) {
    services.udev.extraRules = ''
      # Ignore DualSense Touchpad as a mouse
      ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
