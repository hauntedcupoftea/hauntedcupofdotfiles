{
  pkgs,
  lib,
  ...
}: {
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];
}
