{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ./matugen.nix ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # image = ../../wallpapers/malenia.jpg;
    # base16Scheme = with config.programs.matugen.theme.colors.dark; {
    #   base00 = shadow; # Darkest possible background
    #   base01 = surface_container_lowest; # Slightly lighter background
    #   base02 = surface_container_low; # Selection background
    #   base03 = outline_variant; # Comments (keep dim)

    #   base04 = outline; # Disabled text
    #   base05 = on_surface; # Default text
    #   base06 = inverse_on_surface; # Bright text
    #   base07 = surface_container_highest; # Brightest text

    #   base08 = error; # Red - errors
    #   base09 = on_error; # Bright red/orange - literals
    #   base0A = on_primary; # Bright primary color - classes
    #   base0B = on_secondary; # Bright secondary - strings
    #   base0C = on_tertiary; # Bright tertiary - cyan/regex
    #   base0D = on_primary_container; # High contrast blue - functions
    #   base0E = on_secondary_container; # High contrast purple - keywords
    #   base0F = on_tertiary_container; # High contrast accent - deprecated
    # };
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
