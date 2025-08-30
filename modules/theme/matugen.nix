{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.matugen.nixosModules.default];
  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
    variant = "dark";
    # contrast = 0.24;
    type = "scheme-rainbow";
    package = inputs.matugen.packages.${pkgs.system}.default;
  };

  home-manager.extraSpecialArgs = {
    matugenTheme = config.programs.matugen.theme;
  };
}
