{pkgs, ...}: {
  home.packages = with pkgs; [
    openrazer-daemon
    polychromatic
  ];
}
