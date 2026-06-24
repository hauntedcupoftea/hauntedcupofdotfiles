{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.desktop.teamviewer;
  fishOn = config.dotfiles.shell.fish.enable;
in {
  options.dotfiles.desktop.teamviewer.enable =
    lib.mkEnableOption "TeamViewer remote desktop client";

  config = lib.mkIf cfg.enable {
    packages = [pkgs.teamviewer];

    rum.programs.fish.aliases = lib.mkIf fishOn {
      teamviewer = "env QT_STYLE_OVERRIDE= teamviewer";
    };

    files.".local/share/applications/TeamViewer.desktop".text = ''
      [Desktop Entry]
      Name=TeamViewer (wrapped)
      Exec=env QT_STYLE_OVERRIDE= teamviewer
      Icon=TeamViewer
      Comment=Remote control and meeting solution
      Categories=Network;RemoteAccess;
      Terminal=false
      Type=Application
    '';
  };
}
