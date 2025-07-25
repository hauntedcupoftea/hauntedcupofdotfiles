{ inputs, ... }: {
  imports = [ inputs.kurukurubar.nixosModules.kurukuruDM ];
  programs.kurukuruDM = {
    enable = true;
    settings = {
      wallpaper = ../../custom-files/malenia.jpg;
      instantAuth = true;
      extraConfig = ''
        monitor = DP-2, preferred, auto, 1
      '';
    };
  };
}
