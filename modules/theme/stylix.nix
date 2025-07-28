{ inputs, pkgs, config, ... }:
let
  # Define polarity in one place
  currentPolarity = config.programs.matugen.variant; # Change this to "light" to switch everything

  # Select the right matugen theme based on polarity
  matugenTheme =
    if currentPolarity == "dark"
    then config.programs.matugen.theme.colors.dark
    else config.programs.matugen.theme.colors.light;

in
{
  imports = [ inputs.stylix.nixosModules.stylix ./matugen.nix ];
  stylix = {
    enable = true;
    polarity = currentPolarity;
    image = ../../wallpapers/malenia.jpg;

    # https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    base16Scheme = with matugenTheme;
      if currentPolarity == "light" then {
        base00 = background;
        base01 = surface_container;
        base02 = primary_container;
        base03 = outline;
        base04 = on_surface_variant;
        base05 = on_surface;
        base06 = surface_container_highest;
        base07 = surface_dim;
        base08 = error;
        base09 = tertiary;
        base0A = on_tertiary_container;
        base0B = secondary;
        base0C = primary_container;
        base0D = primary;
        base0E = tertiary_container;
        base0F = on_error_container;
      } else {
        base00 = background;
        base01 = surface_container;
        base02 = primary_container;
        base03 = outline;
        base04 = on_surface_variant;
        base05 = on_surface;
        base06 = surface_container_highest;
        base07 = surface_bright;
        base08 = error;
        base09 = tertiary;
        base0A = tertiary_container;
        base0B = secondary;
        base0C = secondary_fixed;
        base0D = primary;
        base0E = tertiary_fixed;
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
