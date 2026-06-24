{pkgs, ...}: {
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
