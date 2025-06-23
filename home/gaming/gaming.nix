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
    samrewritten
  ];

  programs.mangohud = {
    enable = true;
    # TODO: add settings (copy from goverlay probably)
  };
}
