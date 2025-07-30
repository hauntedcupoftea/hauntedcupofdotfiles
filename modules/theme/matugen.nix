{ inputs, config, ... }: {
  imports = [ inputs.matugen.nixosModules.default ];
  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
    variant = "dark";
    # contrast = 0.24;
    type = "scheme-rainbow";
  };

  home-manager.extraSpecialArgs = {
    matugenTheme = config.programs.matugen.theme.files;
  };
}
