{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.yaml;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.yaml =
    lib.mkEnableOption "YAML language tooling (yaml-language-server)";

  config = lib.mkIf cfg {
    packages = [pkgs.yaml-language-server];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language = [{
        name = "yaml";
        auto-format = true;
        language-servers = ["yaml-language-server"];
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.yaml-language-server.binary.path = lib.getExe pkgs.yaml-language-server;
    };
  };
}
