{ inputs, ... }: {
  imports = [ inputs.matugen.nixosModules.default ];

  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
    variant = "dark";
    contrast = 0.25;
    type = "scheme-vibrant";
  };
}
