{ inputs, config, ... }: {
  imports = inputs.kurukurubar + "/nixosModules/exported/matugen";
  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
    variant = "dark";
    contrast = 0.25;
    type = "scheme-vibrant";
  };

  home-manager.extraSpecialArgs = {
    matugenTheme = config.programs.matugen.theme.files;
  };
}
