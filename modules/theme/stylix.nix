{ inputs, pkgs, config, ... }:
let
  # Define polarity in one place
  currentPolarity = "dark"; # Change this to "light" to switch everything

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
    polarity = currentPolarity; # Use the same polarity value
    image = ../../wallpapers/malenia.jpg;
    base16Scheme = with matugenTheme; {
      # Backgrounds - these work for both light and dark
      base00 = surface_container_lowest;
      base01 = surface_container_low;
      base02 = surface_container_high; # More contrast for selections/highlights
      base03 = outline_variant;

      # Foregrounds - automatically correct for polarity
      base04 = outline;
      base05 = on_surface;
      base06 = surface_bright;
      base07 = surface_container_highest;

      # Accent colors - these should work for both themes
      base08 = error;
      base09 = on_error_container;
      base0A = on_primary_container;
      base0B = on_secondary_container;
      base0C = on_tertiary_container;
      base0D = primary;
      base0E = secondary;
      base0F = tertiary;
    };

    cursor = {
      name = if currentPolarity == "dark" then "phinger-cursors-dark" else "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 40;
    };
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font Mono";
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
