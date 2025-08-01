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

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
    # override = with matugenTheme; {
    #   base00 = background;
    #   base01 = surface_container;
    #   base02 = surface_bright;
    #   base03 = outline;
    #   base04 = secondary;
    #   base05 = on_secondary_container;
    #   # base06 = on_primary_container;
    #   # base07 = on_primary_container;
    #   # base08 = on_error_container;
    #   # base09 = tertiary_fixed;
    #   # base0A = primary_fixed;
    #   # base0B = secondary_fixed;
    #   # base0C = secondary;
    #   # base0D = tertiary;
    #   base0E = primary;
    #   base0F = error_container;
    # };

    # heavily modified but inspo from https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    base16Scheme = with matugenTheme; {
      base00 = background;
      base01 = surface_container;
      base02 = surface_container_high;
      base03 = surface_bright;
      base04 = outline;
      base05 = on_surface_variant;
      base06 = on_background;
      base07 = on_primary_container;
      base08 = error;
      base09 = tertiary;
      base0A = tertiary_fixed;
      base0B = inverse_primary;
      base0C = on_primary;
      base0D = secondary;
      base0E = primary;
      base0F = on_error;
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
