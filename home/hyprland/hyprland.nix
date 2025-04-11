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
    systemd.enable = false;

    settings = {
      # Set default terminal to kitty
      "$terminal" = "kitty";

      # Mod key (usually Alt or Super)
      "$mod" = "SUPER";

      # Basic bindings
      bind =
        [
          "$mod, Q, exec, $terminal"
          "$mod, M, exit"
          "$mod, C, killactive"
          "$mod, B, togglefloating"
          "$mod, V, exec, uwsm app -- $terminal --class clipse -e 'clipse'"
          "$mod, space, exec, uwsm app -- wofi --show drun"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, F, exec, uwsm app -- zen-twilight" # bro i cannot decipher whether zen or zen-beta is the way to go.
          "$mod, E, exec, uwsm app -- $terminal -e yazi"
          ", Print, exec, uwsm app -- grimblast copy area"
          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e-1"
          "$mod, mouse_up, workspace, e+1"
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

      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # multimedia keys for laptops and keyboards that support it.
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      # playerctl binds
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

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
        "float,class:(clipse)"
        "size 622 652,class:(clipse)"
        "stayfocused,class:(clipse)"
      ];

      # Startup applications
      exec-once = [
        "uwsm app -- waybar"
        "uwsm app -- dunst"
        "uwsm app -- nm-applet"
        "uwsm app -- clipse -listen"
      ];
    };
  };
}
