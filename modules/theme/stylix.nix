{
  inputs,
  pkgs,
  config,
  ...
}: let
  currentPolarity = config.programs.matugen.variant;
  matugenTheme = config.programs.matugen.theme.colors;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    ./matugen.nix
  ];

  stylix = {
    enable = true;
    polarity = currentPolarity;
    image = ../../wallpapers/malenia.jpg;

    # heavily modified but inspo from https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    base16Scheme = with matugenTheme; {
      base00 = background."${currentPolarity}";
      base01 = surface_container."${currentPolarity}";
      base02 = surface_container_high."${currentPolarity}";
      base03 = surface_bright."${currentPolarity}";
      base04 = outline."${currentPolarity}";
      base05 = on_surface_variant."${currentPolarity}";
      base06 = on_background."${currentPolarity}";
      base07 = on_primary_container."${currentPolarity}";
      base08 = error."${currentPolarity}";
      base09 = tertiary."${currentPolarity}";
      base0A = tertiary_fixed."${currentPolarity}";
      base0B = inverse_primary."${currentPolarity}";
      base0C = on_primary."${currentPolarity}";
      base0D = secondary."${currentPolarity}";
      base0E = primary."${currentPolarity}";
      base0F = on_error."${currentPolarity}";
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
