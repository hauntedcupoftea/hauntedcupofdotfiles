{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.toml;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.toml =
    lib.mkEnableOption "TOML language tooling (taplo)";

  config = lib.mkIf cfg {
    packages = [pkgs.taplo];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language = [{
        name = "toml";
        auto-format = true;
        language-servers = ["taplo-lsp"];
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.taplo.binary.path = lib.getExe pkgs.taplo;
    };
  };
}
