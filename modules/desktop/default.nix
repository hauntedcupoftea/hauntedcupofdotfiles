{...}: {
  imports = [
    # ./gnome.nix # fallback
    ./fonts.nix
    ./gaming.nix
    ./xserver.nix
    ./hyprland.nix
    ./docker.nix
  ];
}
