{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.kitty;
in {
  options.dotfiles.desktop.kitty.enable =
    lib.mkEnableOption "kitty terminal emulator";

  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    rum.programs.kitty = {
      enable = true;
      integrations.fish.enable = config.dotfiles.shell.fish.enable;
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = true;
        window_alert_on_bell = true;
        update_check_interval = 0;
        shell = lib.getExe pkgs.fish;
        tab_bar_style = "hidden";
        window_padding_width = "1 2";
        font_size = "14.0";
        font_family = "FiraCode Nerd Font";
        background_opacity = "0.85";
        background_blur = 1;
      };
    };
  };
}
