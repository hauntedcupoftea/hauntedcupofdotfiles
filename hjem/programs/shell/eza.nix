{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.eza;
  fishOn = config.dotfiles.shell.fish.enable;
in {
  options.dotfiles.shell.eza.enable =
    lib.mkEnableOption "eza (modern ls replacement)";

  config = lib.mkIf cfg.enable {
    # rum.programs.eza = {
    #   enable = true;
    #   integrations.fish.enable = fishOn;
    #   colors = "auto";
    #   git = true;
    #   icons = "auto";
    # };

    # TODO: theming
    packages = [pkgs.eza];

    rum.programs.fish.aliases = lib.mkIf fishOn {
      ls = "eza";
      ll = "eza -la --icons=auto --git";
      tree = "eza --tree --icons=auto";
    };
  };
}
