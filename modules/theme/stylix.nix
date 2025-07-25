{ inputs, pkgs, config, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ./matugen.nix ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = with config.programs.matugen.theme.colors.dark; {
      base00 = background;
      base01 = surface;
      base02 = surface-variant;
      base03 = on-surface;
      base04 = on-background;
      base05 = primary;
      base06 = primary-variant;
      base07 = on-primary;
      base08 = secondary;
      base09 = on-secondary;
      base0A = tertiary;
      base0B = on-tertiary;
      base0C = error;
      base0D = on-error;
      base0E = secondary-variant;
      base0F = outline;
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
