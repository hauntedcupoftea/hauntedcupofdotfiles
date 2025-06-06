{ pkgs, ... }: {
  home.packages = with pkgs; [
    mangohud
    protonup-qt
    protonplus
    lutris
    bottles
    heroic
    dualsensectl
    wineWowPackages.stable
    winetricks
  ];
}
