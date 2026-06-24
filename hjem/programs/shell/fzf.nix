{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.direnv;
  fishOn = config.dotfiles.shell.fish.enable;
  zshOn = config.dotfiles.shell.zsh.enable;
in {
  options.dotfiles.shell.fzf = {
    enable = lib.mkEnableOption "fzf fuzzy finder";
  };

  config = lib.mkIf cfg.enable {
    rum.programs.fzf = {
      enable = true;
      integrations = {
        fish.enable = fishOn;
        zsh.enable = zshOn;
      };
    };
  };
}
