{...}: {
  imports = [
    # ./gnome.nix # fallback
    ./appimage.nix
    ./cloudflare.nix
    ./fonts.nix
    ./gaming.nix
    ./hyprland.nix
    ./kb.nix
    ./localsend.nix
    ./mail.nix
    ./podman.nix
    ./teamviewer.nix
    ./tailscale.nix
    ./xdg.nix
    ./xserver.nix
  ];
}
