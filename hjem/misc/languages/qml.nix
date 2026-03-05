{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.qml;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
  uwuOn = config.dotfiles.languages.uwu-colors;
in {
  options.dotfiles.languages.qml =
    lib.mkEnableOption "QML language tooling (qmlls — provided by Qt via quickshell deps)";

  config = lib.mkIf cfg {
    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.qmlls = {
        command = "qmlls";
        args = ["-E"];
      };
      language = [{
        name = "qml";
        auto-format = true;
        language-servers = ["qmlls"] ++ lib.optional uwuOn "uwu-colors";
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.qmlls.binary.path = "qmlls";
    };
  };
}
