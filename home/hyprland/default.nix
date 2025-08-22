{...}: {
  imports = [
    ./gammastep.nix
    ./hyprland.nix
    ./hypridle.nix
    # ./wofi.nix # use either this or walker.
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix # I have disabled this.
    # ./osd.nix # swayosd is weird. i'll write my own.
    # ./waybar.nix # goodbye
    ./walker.nix
    ./wleave.nix
    # ./xdph.nix
  ];
}
