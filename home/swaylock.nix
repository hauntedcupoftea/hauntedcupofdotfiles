{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      daemonize = true;
      # timestr="%H:%M";
      datestr = "";
      screenshots = true;
      ignore-empty-password = true;

      indicator = true;
      indicator-radius = 111;
      indicator-thickness = 9;

      effect-blur = "7x5";
      effect-vignette = "0.75:0.75";
      effect-pixelate = 5;

      font = "Maple Mono";

      text-wrong-color = lib.mkDefault "FBF1C7FF";
      text-ver-color = lib.mkDefault "FBF1C7FF";
      text-clear-color = lib.mkDefault "FBF1C7FF";
      key-hl-color = lib.mkDefault "fabd2fFF";
      bs-hl-color = lib.mkDefault "fb4934FF";
      ring-clear-color = lib.mkDefault "d65d0eFF";
      ring-wrong-color = lib.mkDefault "cc241dff";
      ring-ver-color = lib.mkDefault "b8bb26FF";
      ring-color = lib.mkDefault "689d6aff";
      line-clear-color = lib.mkDefault "FFFFFF00";
      line-ver-color = lib.mkDefault "FFFFFF00";
      line-wrong-color = lib.mkDefault "FFFFFF00";
      separator-color = lib.mkDefault "FFFFFF00";
      line-color = lib.mkDefault "FFFFFF00";
      text-color = lib.mkDefault "FBF1C7FF";
      inside-color = lib.mkDefault "3C3836DD";
      inside-ver-color = lib.mkDefault "3C3836DD";
      inside-clear-color = lib.mkDefault "3C3836DD";
      inside-wrong-color = lib.mkDefault "3C3836DD";
      layout-bg-color = lib.mkDefault "FFFFFF00";
      layout-text-color = lib.mkDefault "FBF1C7FF";
    };
  };
}
