{ inputs, ... }: {
  imports = [ inputs.matugen.nixosModules.default ];

  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
  };
}
