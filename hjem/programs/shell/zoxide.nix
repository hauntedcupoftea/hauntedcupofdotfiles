{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.direnv;
  fishOn = config.dotfiles.shell.fish.enable;
  nushellOn = config.dotfiles.shell.nushell.enable;
  zshOn = config.dotfiles.shell.zsh.enable;
in {
  options.dotfiles.shell.zoxide = {
    enable = lib.mkEnableOption "zoxide smarter cd";
  };

  config = lib.mkIf cfg.enable {
    rum.programs.zoxide = {
      enable = true;
      integrations = {
        fish.enable = fishOn;
        nushell.enable = nushellOn;
        zsh.enable = zshOn;
      };
    };
  };
}
