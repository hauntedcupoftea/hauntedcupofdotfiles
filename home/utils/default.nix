{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./misc
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    appimage-run
  ];
}
