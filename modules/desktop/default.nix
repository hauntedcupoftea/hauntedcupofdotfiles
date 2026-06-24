{...}: {
  imports = [
    # ./gnome.nix # fallback
    ./appimage.nix
    ./cloudflare.nix
    ./dualsense.nix
    ./dsc.nix
    ./fonts.nix
    ./gaming.nix

    ./cursors.nix
    ./hyprland.nix
    ./quickshell.nix
    ./services.nix

    ./kb.nix
    ./localsend.nix
    ./mail.nix
    ./podman.nix
    ./services.nix
    # ./teamviewer.nix
    ./tailscale.nix
    ./udisks2.nix
    ./waydroid.nix
    ./xdg.nix
    ./xserver.nix
  ];
}
