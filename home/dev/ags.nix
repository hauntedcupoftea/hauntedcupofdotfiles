{pkgs, ...}: {
  home.packages = [
    pkgs.ags
    pkgs.gtk4
    pkgs.gtk4-layer-shell
  ];
}
