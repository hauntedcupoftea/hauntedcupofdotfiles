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
          "$mod, B, togglefloating"
          "$mod, V, exec,  $terminal --class clipse -e 'clipse'"
          "$mod, space, exec, wofi --show drun"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, F, exec, zen"
          "$mod, E, exec, $terminal -e yazi"
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

      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        "5, persistent:true"
      ];

      # Window Rules
      windowrule = [
        "float,class:(clipse)" # ensure you have a floating window class set if you want this behavior
        "size 622 652,class:(clipse)" # set the size of the window as necessary
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "dunst"
        "nm-applet"
        "clipse -listen"
      ];
    };
  };
}
