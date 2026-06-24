{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.desktop.vesktop;
  jsonFormat = pkgs.formats.json {};

  mkRecursiveFiles = targetBase: srcDir:
    if srcDir == null
    then {}
    else let
      walk = dir: prefix: let
        entries = builtins.readDir dir;
        files =
          lib.mapAttrsToList (
            name: type:
              if type == "directory"
              then walk (dir + "/${name}") (prefix + "/${name}")
              else if type == "regular"
              then [
                {
                  target = "${targetBase}${prefix}/${name}";
                  source = dir + "/${name}";
                }
              ]
              else []
          )
          entries;
      in
        lib.flatten files;
      all = walk srcDir "";
    in
      lib.listToAttrs (map (item: lib.nameValuePair item.target {source = item.source;}) all);
in {
  options.dotfiles.desktop.vesktop = {
    enable = lib.mkEnableOption "Vesktop Discord client with Vencord";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.vesktop;
      description = "Vesktop package to use. Set null to skip adding to packages.";
    };

    arrpc.enable = lib.mkEnableOption "arrpc (Discord RPC bridge)";
    settings = lib.mkOption {
      type = jsonFormat.type;
      default = {};
      description = "Vesktop settings (see upstream docs)";
      example = {
        customTitleBar = false;
        disableMinSize = true;
        arRPC = true;
        hardwareVideoAcceleration = true;
        hardwareAcceleration = true;
        splashThemeing = true;
      };
    };
    themeDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory containing .css theme files (copied recursively to vesktop/themes/)";
    };
    settingsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory containing extra settings files (e.g., QuickCss, etc.) copied recursively to vesktop/settings/";
    };

    vencord = {
      useSystem = lib.mkEnableOption "use Vencord package from Nixpkgs (overrides vesktop package)";

      settings = lib.mkOption {
        type = jsonFormat.type;
        default = {};
        description = "Vencord plugin settings (settings/settings.json)";
      };

      extraQuickCss = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional CSS injected into Vesktop (quickCss.css)";
      };
      themes = lib.mkOption {
        type = lib.types.attrsOf (lib.types.either lib.types.lines lib.types.path);
        default = {};
        description = "CSS themes as attribute set (filename -> CSS content or path)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs;
      (lib.optional (cfg.package != null)
        (
          if cfg.vencord.useSystem
          then cfg.package.override {withSystemVencord = true;}
          else cfg.package
        ))
      ++ lib.optional cfg.arrpc.enable arrpc;

    xdg.config.files = lib.mkMerge [
      (lib.mkIf (cfg.settings != {}) {
        "vesktop/settings.json".source = jsonFormat.generate "vesktop-settings.json" cfg.settings;
      })
      (lib.mkIf (cfg.vencord.settings != {}) {
        "vesktop/settings/settings.json".source = jsonFormat.generate "vencord-settings.json" cfg.vencord.settings;
      })
      (lib.mkIf (cfg.vencord.extraQuickCss != "") {
        "vesktop/settings/quickCss.css".text = cfg.vencord.extraQuickCss;
      })
      (lib.mapAttrs (name: content: {
          "vesktop/themes/${name}.css".source =
            if builtins.isPath content || lib.isStorePath content
            then content
            else pkgs.writeText "${name}.css" content;
        })
        cfg.vencord.themes)
      (mkRecursiveFiles "vesktop/themes" cfg.themeDir)
      (mkRecursiveFiles "vesktop/settings" cfg.settingsDir)
    ];
  };
}
