{ inputs
, system
, ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      QueueTime
      powerBar
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      keyboardShortcut
      lastfm
      fullAlbumDate
      oneko
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      betterLibrary
      ncsVisualizer
      newReleases
      reddit
    ];
    enabledSnippets = with spicePkgs.snippets; [
      rotatingCoverart
      pointer
      hideLyricsButton
      oneko
    ];
    wayland = true;
  };
}
