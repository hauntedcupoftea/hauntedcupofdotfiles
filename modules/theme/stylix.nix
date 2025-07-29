{ inputs, pkgs, config, ... }:
let
  currentPolarity = config.programs.matugen.variant;
  matugenTheme =
    if currentPolarity == "dark"
    then config.programs.matugen.theme.colors.dark
    else config.programs.matugen.theme.colors.light;

in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./matugen.nix
  ];

  stylix = {
    enable = true;
    polarity = currentPolarity;
    image = ../../wallpapers/malenia.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";

    # heavily modified but inspo from https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    override = with matugenTheme; {
      base00 = background;
      base01 = surface_container;
      base02 = surface_bright;
      base03 = outline;
      base04 = on_surface_variant;
      base05 = on_surface;
      base06 = on_primary_container;
      base07 = primary_fixed;
      # base08 = on_error_container;
      # base09 = tertiary;
      # base0A = primary_fixed;
      # base0B = secondary_fixed;
      # base0C = secondary;
      # base0D = error;
      # base0E = primary;
      # base0F = tertiary_container;
    };
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 36;
    };
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sizes = {
        popups = 13;
        applications = 13;
        terminal = 13;
        desktop = 14;
      };
    };
    opacity = {
      terminal = 0.85;
      desktop = 0.85;
    };
  };
}
