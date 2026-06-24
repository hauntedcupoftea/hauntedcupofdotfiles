{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.uwu-colors;
  helixOn = config.dotfiles.shell.helix.enable;
in {
  options.dotfiles.languages.uwu-colors =
    lib.mkEnableOption "uwu-colors LSP (inline color previews for CSS/QML/Svelte)";

  config = lib.mkIf cfg {
    packages = [pkgs.uwu-colors];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.uwu-colors.command = "${pkgs.uwu-colors}/bin/uwu_colors";
    };
  };
}
