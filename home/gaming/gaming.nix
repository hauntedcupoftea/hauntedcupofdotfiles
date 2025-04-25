{pkgs, ...}: {
  home.packages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];
}
