{ inputs, pkgs, config, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ./matugen.nix ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = with config.programs.matugen.theme.colors.dark; {
      base00 = surface_container_lowest;
      base01 = surface_container_low;
      base02 = surface_container;

      base03 = outline;
      base04 = on_surface_variant;
      base05 = on_surface;
      base06 = surface_container_high;
      base07 = surface_container_highest;

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
