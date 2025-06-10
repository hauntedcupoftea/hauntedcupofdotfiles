{ pkgs
, lib
, config
, inputs
, ...
}:
let
  # Extract hostname from the flake target
  # This is a simplified example - actual implementation may need adjustment
  isGE66Raider = builtins.hasAttr "ge66-raider" (inputs.self.nixosConfigurations or { });
in
{
  # Hyprland home configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      # Set default terminal to kitty
      "$terminal" = "kitty";

      # Mod key (usually Alt or Super)
      "$mod" = "SUPER";
      "$altMod" = "SUPER_SHIFT";

      # Basic bindings
      bind =
        [
          "$mod, Q, exec, uwsm app -- $terminal"
          "$mod, M, exec, uwsm app -- wlogout"
          "$mod, C, killactive"
          "$mod, B, togglefloating"
          "$mod, V, exec, uwsm app -- $terminal --class clipse -e 'clipse'"
          "$mod, space, exec, uwsm app -- walker"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, F, exec, uwsm app -- zen-twilight" # bro i cannot decipher whether zen or zen-beta is the way to go.
          "$mod, E, exec, uwsm app -- $terminal -e yazi"
          # Screenshot a region (freezing)
          ", Print, exec, uwsm app -- grimblast copy area --notify"
          # Screenshot a region (non-freezing)
          "$altMod, PRINT, exec, uwsm app -- hyprshot -m region --clipboard-only"
          # Screenshot a monitor
          "SUPER_ALT, PRINT, exec, uwsm app -- hyprshot -m output"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e-1"
          "$mod, mouse_up, workspace, e+1"

          # Alt Mods (color pickers, calculator, etc.)
          "$altMod, c, exec, uwsm app -- hyprpicker -a"
          # "$altMod, space, exec, uwsm app -- $terminal --class kalker -e kalker -r --no-leading-eq"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList
            (
              i:
              let
                ws = i + 1;
              in
              [
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

      workspace = lib.mkIf isGE66Raider [
        "1,persistent:true,monitor:DP-2"
        "2,persistent:true,monitor:DP-2"
        "3,persistent:true,monitor:DP-2"
        "4,persistent:true,monitor:eDP-1"
        "5,persistent:true,monitor:eDP-1"
        "6,persistent:true,monitor:eDP-1"
      ];

      # Window Rules
      windowrule = [
        "float,class:(clipse)"
        "size 622 652,class:(clipse)"
        "stayfocused,class:(clipse)"
        # "float,class:(kalker)"
        # "size 622 652,class:(kalker)"
        # "stayfocused,class:(kalker)"
      ];

      # Startup applications
      exec-once = [
        "uwsm app -- waybar"
        "uwsm app -- dunst"
        "uwsm app -- clipse -listen"
        # "uwsm app -- walker --gapplication-service" # there is a chance walker already runs it as a systemd service.
      ];
    };
  };
}
