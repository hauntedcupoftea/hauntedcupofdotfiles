{...}: {
  imports = [
    # ./gnome.nix # fallback
    ./appimage.nix
    ./fonts.nix
    ./gaming.nix
    ./xserver.nix
    ./hyprland.nix
    ./podman.nix
    ./teamviewer.nix
    ./xdg.nix
    ./mail.nix
  ];
}
