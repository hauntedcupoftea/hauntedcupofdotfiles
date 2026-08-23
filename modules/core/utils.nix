{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.nix-index
  ];

  programs.cfs-zen-tweaks.enable = true;
  programs.nano.enable = false;
}
