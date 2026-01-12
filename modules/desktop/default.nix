{...}: {
  imports = [
    # ./gnome.nix # fallback
    ./appimage.nix
    ./fonts.nix
    ./gaming.nix
    ./kb.nix
    ./xserver.nix
    ./hyprland.nix
    ./podman.nix
    ./teamviewer.nix
    ./tailscale.nix
    ./xdg.nix
    ./mail.nix
    ./localsend.nix
  ];
}
