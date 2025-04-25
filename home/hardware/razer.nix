{pkgs, ...}: {
  hardware.openrazer.enable = true;
  home.packages = with pkgs; [
    openrazer-daemon
    polychromatic
  ];
}
