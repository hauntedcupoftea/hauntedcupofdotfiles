{ pkgs
, ...
}: {
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
      protontricks.enable = true;
    };

    gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    };

    # gamescope = {
    #   enable = true;
    #   capSysNice = true;
    #   args = [
    #     "--backend sdl"
    #     "--rt"
    #   ];
    # };
  };
}
