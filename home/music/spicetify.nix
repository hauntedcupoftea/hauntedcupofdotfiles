{
  pkgs,
  lib,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      keyboardShortcut
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      marketplace
    ];
    theme = spicePkgs.themes.text;
    colorScheme = "catppuccin-mocha";
  };
}
