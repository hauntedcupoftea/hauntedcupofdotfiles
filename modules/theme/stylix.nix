{ inputs, pkgs, config, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ./matugen.nix ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = with config.programs.matugen.theme.colors.dark; {
      # Backgrounds
      base00 = surface_container_lowest;
      base01 = surface_container_low;
      base02 = surface_container;

      # Foregrounds
      base03 = on_surface_variant; # Comments
      base04 = on_surface; # Default
      base05 = on_primary_container; # Bright
      base06 = on_secondary_container; # Brighter
      base07 = on_tertiary_container; # Brightest

      # Accents
      base08 = error; # Red
      base09 = tertiary; # Orange
      base0A = primary; # Yellow
      base0B = secondary; # Green
      base0C = tertiary_container; # Cyan
      base0D = primary_container; # Blue
      base0E = secondary_container; # Magenta
      base0F = outline; # Misc
    };
    cursor = {
      name = "phinger-cursors-dark";
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
