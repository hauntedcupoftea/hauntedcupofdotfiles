{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    dunst.enable = true;
    btop.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    hyprland.enable = true;
  };
}
