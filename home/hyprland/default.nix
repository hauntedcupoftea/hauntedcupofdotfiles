{ ... }: {
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    # ./wofi.nix # use either this or walker.
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./waybar.nix
    ./walker.nix
    ./wlogout.nix
    ./wlsunset.nix
  ];
}
