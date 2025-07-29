{ inputs, pkgs, config, ... }:
let
  currentPolarity = config.programs.matugen.variant;
  # matugenTheme =
  #   if currentPolarity == "dark"
  #   then config.programs.matugen.theme.colors.dark
  #   else config.programs.matugen.theme.colors.light;

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

    # heavily modified but inspo from https://github.com/make-42/stylix/blob/matugen-clean-diff-rebuild/stylix/palette.nix
    base16Scheme = {
      base00 = "1e1e2e";
      base01 = "181825";
      base02 = "313244";
      base03 = "45475a";
      base04 = "585b70";
      base05 = "cdd6f4";
      base06 = "f5e0dc";
      base07 = "b4befe";
      base08 = "f38ba8";
      base09 = "fab387";
      base0A = "f9e2af";
      base0B = "a6e3a1";
      base0C = "94e2d5";
      base0D = "89b4fa";
      base0E = "cba6f7";
      base0F = "f2cdcd";
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
