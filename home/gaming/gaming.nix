{ pkgs, ... }: {
  home.packages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    dualsensectl
  ];
  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = 0;
  };
}
