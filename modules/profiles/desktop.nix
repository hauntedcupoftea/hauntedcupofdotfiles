{lib, ...}: {
  options.dotfiles.desktop = {
    enable = lib.mkEnableOption "desktop profile";

    environment = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["hyprland" "plasma" "gnome" "cosmic"]);
      default = ["hyprland"];
    };

    gaming.enable = lib.mkEnableOption "gaming packages and services";
    audio.enable = lib.mkEnableOption "audio stack (pipewire, wireplumber)";

    monitors = lib.mkOption {
      default = [];
      description = "Monitor configuration passed to the compositor. Empty means compositor decides.";
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Connector name e.g. DP-2 or eDP-1.";
          };
          resolution = lib.mkOption {
            type = lib.types.str;
            description = "Resolution string e.g. 2560x1440.";
          };
          refreshRate = lib.mkOption {
            type = lib.types.int;
            description = "Refresh rate in Hz.";
          };
          position = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "Position string e.g. 0x0.";
          };
          scale = lib.mkOption {
            type = lib.types.number;
            default = 1;
            description = "Display scale factor.";
          };
          vrr = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable variable refresh rate.";
          };
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Primary monitor for workspace assignment.";
          };
        };
      });
    };
  };
}
