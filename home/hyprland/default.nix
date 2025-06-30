{ ... }: {
  imports = [
    ./gammastep.nix
    ./hyprland.nix
    ./hypridle.nix
    # ./wofi.nix # use either this or walker.
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./osd.nix
    ./waybar.nix
    ./walker.nix
    ./wleave.nix
  ];
}
