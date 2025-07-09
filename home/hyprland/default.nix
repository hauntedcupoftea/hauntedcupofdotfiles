{ ... }: {
  imports = [
    ./gammastep.nix
    ./hyprland.nix
    ./hypridle.nix
    # ./wofi.nix # use either this or walker.
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    # ./osd.nix # swayosd is weird. i'll write my own.
    ./waybar.nix
    ./walker.nix
    ./wleave.nix
    ./xdph.nix
  ];
}
