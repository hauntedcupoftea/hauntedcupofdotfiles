{ inputs, ... }: {
  imports = [ inputs.kurukurubar.nixosModules.kurukuruDM ];
  programs.kurukuruDM = {
    enable = true;
    settings = {
      wallpaper = ../../wallpapers/malenia.jpg;
      instantAuth = true;
      extraConfig = ''
        monitor = DP-2, preferred, auto, 1
      '';
    };
  };
}
