{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      package = pkgs.millennium-steam.override {
        extraProfile = ''
          export MANGOHUD=1
          export GAMEMODERUN=1
          export PROTON_ENABLE_WAYLAND=1
          export PROTON_DLSS_UPGRADE=1
          unset TZ
        '';
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      # nix-gaming
      platformOptimizations.enable = true;
      protontricks.enable = true;
    };

    gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--backend sdl"
      ];
    };
  };
}
