{
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.shell.direnv;
  isNixos = nixosConfig != null;
  fishOn = config.dotfiles.shell.fish.enable;
  nushellOn = config.dotfiles.shell.nushell.enable;
  zshOn = config.dotfiles.shell.zsh.enable;
in {
  options.dotfiles.shell.direnv = {
    enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkIf cfg.enable {
    rum.programs.direnv = {
      enable = true;
      integrations = {
        # TODO: maybe this needs to be linked to whether the config is on nixos?
        nix-direnv.enable = isNixos;
        fish.enable = fishOn;
        nushell.enable = nushellOn;
        zsh.enable = zshOn;
      };
    };
  };
}
