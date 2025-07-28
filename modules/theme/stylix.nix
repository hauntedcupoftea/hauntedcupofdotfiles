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

    # heavily modified but inspo from https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    base16Scheme = with matugenTheme; {
      base00 = background;
      base01 = surface_container;
      base02 = surface_bright;
      base03 = secondary_container;
      base04 = outline;
      base05 = on_primary_container;
      base06 = on_background;
      base07 = primary_container;
      base08 = error;
      base09 = tertiary_fixed;
      base0A = tertiary;
      base0B = secondary;
      base0C = secondary_fixed;
      base0D = on_primary;
      base0E = primary;
      base0F = error_container;
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
