{ pkgs
, inputs
, ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      keyboardShortcut
      lastfm
      fullAlbumDate
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      marketplace
      betterLibrary
      ncsVisualizer
    ];
    theme = spicePkgs.themes.text;
    colorScheme = "CatppuccinMocha";
  };
}
