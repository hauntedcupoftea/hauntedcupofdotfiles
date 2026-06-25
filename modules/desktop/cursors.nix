{
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.desktop;
  isHyprlandEnabled = cfg.enable && (builtins.elem "hyprland" cfg.environment);
in {
  config = lib.mkIf isHyprlandEnabled {
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Bibata-Modern-Classic";
            cursor-size = lib.gvariant.mkInt32 28;
          };
        };
      }
    ];
  };
}
