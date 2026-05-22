{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.desktop.walker;
  tomlFormat = pkgs.formats.toml {};
  hasDesktop = nixosConfig.dotfiles.desktop.enable or false;
in {
  options.dotfiles.desktop.walker = {
    enable = lib.mkEnableOption "walker launcher (requires elephant)";

    package = lib.mkPackageOption pkgs "walker" {};

    runAsService = lib.mkEnableOption "run walker as a user service";

    config = lib.mkOption {
      type = tomlFormat.type;
      default = {};
      description = "Walker TOML config";
    };

    themes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.style = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      });
      default = {};
      description = "Custom themes (optional)";
    };

    elephant = {
      enable = lib.mkEnableOption "elephant backend (required for walker)";
      package = lib.mkPackageOption pkgs "elephant" {};
      installService = lib.mkEnableOption "install elephant systemd user service" // {default = true;};
      debug = lib.mkEnableOption "debug logging for elephant";
      settings = lib.mkOption {
        type = tomlFormat.type;
        default = {};
        description = "elephant.toml config";
      };
      providers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "bluetooth"
          "bookmarks"
          "calc"
          "clipboard"
          "desktopapplications"
          "files"
          "menus"
          "playerctl"
          "providerlist"
          "runner"
          "snippets"
          "symbols"
          "todo"
          "unicode"
          "websearch"
          "windows"
          "bitwarden"
          "1password"
          "nirisessions"
          "niriactions"
        ];
        description = "List of elephant provider .so files to enable";
      };
      providerSettings = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.settings = lib.mkOption {
            type = tomlFormat.type;
            default = {};
          };
        });
        default = {};
        description = "Provider‑specific TOML settings (written to elephant/<name>.toml)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package] ++ lib.optional cfg.elephant.enable cfg.elephant.package;

    xdg.config.files = lib.mkMerge [
      # Walker main config
      {
        "walker/config.toml".source = tomlFormat.generate "walker-config.toml" cfg.config;
      }
      # Walker themes
      (lib.mapAttrs (name: theme: {
          "walker/themes/${name}/style.css".text = theme.style;
        })
        cfg.themes)
      # Elephant main config
      (lib.mkIf cfg.elephant.enable {
        "elephant/elephant.toml".source = tomlFormat.generate "elephant.toml" cfg.elephant.settings;
      })
      # Elephant provider‑specific configs
      (lib.mkIf cfg.elephant.enable (lib.mapAttrs (name: {settings}: {
        "elephant/${name}.toml".source = tomlFormat.generate "${name}.toml" settings;
      }) (lib.filterAttrs (_: v: v.settings != {}) cfg.elephant.providerSettings)))
      # Elephant provider shared objects
      (lib.mkIf cfg.elephant.enable (lib.listToAttrs (map (
          provider:
            lib.nameValuePair "elephant/providers/${provider}.so" {
              source = "${cfg.elephant.package}/lib/elephant/providers/${provider}.so";
            }
        )
        cfg.elephant.providers)))
    ];

    systemd.services = lib.mkIf (hasDesktop && cfg.elephant.enable) {
      elephant = lib.mkIf cfg.elephant.installService {
        description = "Elephant launcher backend";
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.elephant.package}/bin/elephant ${lib.optionalString cfg.elephant.debug "--debug"}";
          Restart = "on-failure";
          RestartSec = 1;
          ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/elephant.sock";
        };
      };
      walker = lib.mkIf cfg.runAsService {
        description = "Walker launcher";
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target" "elephant.service"];
        requires = ["elephant.service"];
        partOf = ["graphical-session.target"];
        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/walker --gapplication-service";
          Restart = "on-failure";
        };
      };
    };
  };
}
