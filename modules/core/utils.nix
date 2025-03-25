{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.nix-index
  ];
}
