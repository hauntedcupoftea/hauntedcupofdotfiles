{ inputs, config, pkgs, ... }: {
  imports = [ (inputs.kurukurubar + "/nixosModules/external/matugen") ];
  programs.matugen = {
    enable = true;
    wallpaper = ../../wallpapers/malenia.jpg;
    variant = "dark";
    contrast = 0.16;
    type = "scheme-fidelity";
    package = pkgs.matugen;
  };

  home-manager.extraSpecialArgs = {
    matugenTheme = config.programs.matugen.theme.files;
  };
}
