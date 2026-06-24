{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.environments.hyprland.hypridle;
  hasHyprland =
    nixosConfig.dotfiles.desktop.enable or false
    && (builtins.elem "hyprland" (nixosConfig.dotfiles.desktop.environment or []));

  # Convert Nix attrset to hypridle.conf (same syntax as HM’s toHyprconf)
  toHyprconf = attrs: let
    renderValue = v:
      if v == true
      then "true"
      else if v == false
      then "false"
      else if builtins.isString v
      then ''"${v}"''
      else if builtins.isInt v
      then toString v
      else if builtins.isFloat v
      then toString v
      else if builtins.isList v
      then "[" + (lib.concatMapStringsSep ", " renderValue v) + "]"
      else if builtins.isAttrs v
      then "{\n" + (lib.concatStrings (lib.mapAttrsToList (n: v: "  ${n} = ${renderValue v};\n") v)) + "}"
      else abort "unsupported type";
  in
    lib.concatStrings (lib.mapAttrsToList (name: value: "${name} = ${renderValue value};\n") attrs);
in {
  options.dotfiles.environments.hyprland.hypridle = {
    enable = lib.mkEnableOption "Hypridle (Hyprland idle daemon)";
    package = lib.mkPackageOption pkgs "hypridle" {};
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Hypridle configuration (Nix attrset, written to hypr/hypridle.conf)";
      example = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "quickshell -p /path/to/project ipc call lockscreen lock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
        ];
      };
    };
    systemdTarget = lib.mkOption {
      type = lib.types.str;
      default = "graphical-session.target";
      description = "Systemd target to bind to (e.g., hyprland-session.target)";
    };
  };

  config = lib.mkIf (cfg.enable && hasHyprland) {
    packages = [cfg.package];

    xdg.config.files."hypr/hypridle.conf" = lib.mkIf (cfg.settings != {}) {
      text = toHyprconf cfg.settings;
    };

    systemd.services.hypridle = {
      description = "Hypridle – idle management daemon for Hyprland";
      wantedBy = [cfg.systemdTarget];
      after = [cfg.systemdTarget];
      partOf = [cfg.systemdTarget];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = 10;
      };
    };
  };
}
