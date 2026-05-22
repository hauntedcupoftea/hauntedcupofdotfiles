{
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.services.podman;
in {
  options.dotfiles.services.podman.enable = lib.mkEnableOption "podman containerisation";

  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  };
}
