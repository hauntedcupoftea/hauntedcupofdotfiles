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
    # maybe someday
    # rum.programs.eza = {
    #   enable = true;
    #   integrations.fish.enable = fishOn;
    #   colors = "auto";
    #   git = true;
    #   icons = "auto";
    # };

    # TODO: theming
    packages = [pkgs.eza];

    dotfiles.shell.fish.shellAliases = lib.mkIf fishOn {
      ls = "eza";
      ll = "eza -la --icons=auto --git";
      tree = "eza --tree --icons=auto";
      la = "eza -a --icons=auto"; # all files, no details
      lt = "eza -la --icons=auto --git --sort=modified"; # sorted by modification time, newest first
      lr = "eza -la --icons=auto --git --sort=size"; # sorted by size, largest first
      lx = "eza -la --icons=auto --git --sort=ext"; # grouped by extension
      td = "eza --tree --icons=auto --only-dirs"; # tree of directories only
    };
  };
}
