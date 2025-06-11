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
    goverlay
  ];

  programs.mangohud = {
    enable = true;
    # TODO: add settings (copy from goverlay probably)
  };
}
