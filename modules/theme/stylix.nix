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
        base02 = surface_container_highest;
        base03 = outline;
        base04 = on_surface_variant;
        base05 = on_surface;
        base06 = surface_dim; # Changed from on_secondary_fixed (was white)
        base07 = surface_container_low; # Changed from on_primary_container (was white)
        base08 = error;
        base09 = on_tertiary;
        base0A = on_secondary_container;
        base0B = on_secondary_fixed_variant;
        base0C = surface_bright; # Changed from on_primary_fixed (was white)
        base0D = surface_tint;
        base0E = surface_container_high; # Changed from on_tertiary_fixed (was white)
        base0F = on_error_container;
      } else {
        base00 = background;
        base01 = surface_container;
        base02 = secondary_fixed_dim;
        base03 = outline_variant;
        base04 = on_surface_variant;
        base05 = on_surface;
        base06 = secondary_fixed;
        base07 = surface_bright; # Changed from on_primary_container (was white)
        base08 = error;
        base09 = tertiary;
        base0A = secondary;
        base0B = primary;
        base0C = primary_fixed;
        base0D = surface_tint;
        base0E = tertiary_fixed;
        base0F = on_error; # Changed from on_error_container (was white)
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
