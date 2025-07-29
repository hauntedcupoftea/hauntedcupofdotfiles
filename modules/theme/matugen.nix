{ inputs, config, pkgs, ... }: {
  imports = [ inputs.matugen.nixosModules.default ];
  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/fern.png;
    variant = "dark";
    # contrast = 0.24;
    # type = "scheme-";
    package = pkgs.matugen;
  };

  home-manager.extraSpecialArgs = {
    matugenTheme = config.programs.matugen.theme.files;
  };
}
