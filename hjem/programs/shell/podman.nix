{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.shell.podman;
in {
  options.dotfiles.shell.podman.enable = lib.mkEnableOption "podman user tooling";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.dotfiles.services.podman.enable;
        message = "dotfiles.shell.podman requires dotfiles.podman.enable = true at the NixOS level.";
      }
    ];

    packages = with pkgs; [podman-tui podman-compose dive];

    rum.programs.fish.config = lib.mkIf config.dotfiles.shell.fish.enable ''
      alias docker="podman"
    '';
  };
}
