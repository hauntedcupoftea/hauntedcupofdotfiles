{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  # Extract hostname from the flake target
  # This is a simplified example - actual implementation may need adjustment
  isGE66Raider = builtins.hasAttr "ge66-raider" (inputs.self.nixosConfigurations or {});
in {
  # Hyprland home configuration
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Set default terminal to kitty
      "$terminal" = "kitty";

      # Mod key (usually Alt or Super)
      "$mod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      # Basic bindings
      bind =
        [
          "$mod, Q, exec, $terminal"
          "$mod, M, exit"
          "$mod, C, killactive"
          "$mod, V, togglefloating"
          "$mod, space, exec, wofi --show drun"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, F, exec, floorp"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      # Monitor configuration (adjust as needed) (add your own config below)
      monitor = lib.mkIf isGE66Raider [
        "DP-2, 2560x1440@164.96, 0x0, 1"
        "eDP-1, 1920x1080@240, 2560x360, 1"
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "dunst"
        "nm-applet"
      ];
    };
  };
}
