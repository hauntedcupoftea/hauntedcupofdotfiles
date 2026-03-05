{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop.zed;
in {
  options.dotfiles.desktop.zed = {
    enable = lib.mkEnableOption "Zed editor";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra settings merged into rum.programs.zed.settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    rum.programs.zed = {
      enable = true;
      settings = lib.mkMerge [
        {
          hard_tabs = true;
          tab_size = 2;
          disable_ai = true;
          helix_mode = true;
          telemetry = {
            diagnostics = true;
            metrics = false;
          };
          icon_theme = {
            mode = "dark";
            light = "Zed (Default)";
            dark = "Colored Zed Icons Theme Dark";
          };
          ui_font_family = "FiraCode Nerd Font";
          ui_font_size = 18;
        }
        cfg.settings
      ];
    };
  };
}
