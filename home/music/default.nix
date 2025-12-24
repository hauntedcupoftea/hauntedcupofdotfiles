{pkgs, ...}: {
  imports = [
    # ./spicetify.nix
    ./cava.nix
    ./mpd.nix
    ./youtube-music.nix
  ];

  home.packages = [pkgs.easytag];
}
