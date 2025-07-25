{ inputs, ... }: {
  imports = [ inputs.kurukurubar.nixosModules.kurukuruDM ];
  programs.kurukuruDM = {
    enable = true;
    settings = {
      wallpaper = ../../wallpapers/malenia.jpg;
      instantAuth = false;
      extraConfig = ''
        monitor = DP-2, preferred, auto, 1
      '';
    };
  };
}
