{
  pkgs,
  lib,
  config,
  ...
}: {
  # Hyprland home configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      # Set default terminal to kitty
      "$terminal" = "kitty";

      # Mod key (usually Alt or Super)
      "$mod" = "SUPER";

      # Basic bindings
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, M, exit"
        "$mod, C, killactive"
        "$mod, V, togglefloating"
        "$mod, R, exec, wofi --show drun"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];

      # Monitor configuration (adjust as needed)
      monitor = [
        # Example: ", preferred, auto, 1"
        # Replace with your specific monitor setup
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "dunst"
        "nm-applet"
      ];
    };
  };

  # Ensure kitty is the default terminal
  home.packages = with pkgs; [
    kitty
    wofi # Application launcher
    dunst # Notification daemon
  ];
}
