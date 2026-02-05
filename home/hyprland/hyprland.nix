{
  lib,
  inputs,
  pkgs,
  ...
}: let
  isGE66Raider = builtins.hasAttr "Anand-GE66-Raider" (inputs.self.nixosConfigurations or {});
in {
  home.sessionVariables = {
    HYPRSHOT_DIR = "Pictures";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  imports = [inputs.hyprland.homeManagerModules.default];

  # catppuccin.hyprland = {
  #   enable = true;
  # };

  # Hyprland home configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
      patches = [../../custom-files/patches/hypr-glaze-patch.txt];
    };

    settings = {
      # Set default terminal to kitty
      "$terminal" = "kitty";

      # Mod key (usually Alt or Super)
      "$mod" = "SUPER";
      "$altMod" = "SUPER_SHIFT";

      general = {
        gaps_in = 6;
        gaps_out = "8";
      };

      env = ["XDG_CURRENT_DESKTOP,Hyprland"];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        force_default_wallpaper = 0;
        vrr = 3; # Variable refresh rate (set to 1 if your monitor supports it)
      };
      decoration = {
        rounding = 8;
      };

      # Basic bindings
      bind =
        [
          "$mod, return, exec, uwsm app -- $terminal"
          "$mod, Q, killactive"
          "$mod, B, togglefloating"
          "$mod, F, fullscreen"
          "$mod, P, pin" # TODO: test
          "$mod, V, exec, uwsm app -- $terminal --class clipse -e 'clipse'"
          # walker-binds
          "$mod, space, exec, uwsm app -- walker" # standard run

          # Move focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          "$mod, Z, exec, uwsm app -- zen" # bro i cannot decipher whether zen or zen-beta is the way to go.
          "$mod, E, exec, uwsm app -- $terminal -e yazi"
          # Screenshot a region (freezing)
          ", Print, exec, uwsm app -- grimblast copy area --notify"
          # Screenshot a region (non-freezing)
          "$altMod, PRINT, exec, uwsm app -- hyprshot -m region --clipboard-only"
          # Screenshot a monitor
          "SUPER, PRINT, exec, uwsm app -- hyprshot -m output"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e-1"
          "$mod, mouse_up, workspace, e+1"

          # Alt Mods (color pickers, calculator, etc.)
          "$altMod, c, exec, uwsm app -- hyprpicker -a"
        ]
        ++ (
          # Binds $mod + [shift +] {1...9} to [move to] workspace {1...9}
          let
            keymap = ["m" "comma" "period" "j" "k" "l" "u" "i" "o"];
          in
            builtins.concatLists (builtins.genList
              (
                i: let
                  ws = i + 1;
                  key = builtins.elemAt keymap i;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"

                  "$mod, ${key}, workspace, ${toString ws}"
                  "$mod SHIFT, ${key}, movetoworkspace, ${toString ws}"
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

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      monitor = lib.mkMerge [
        (lib.mkIf isGE66Raider [
          "DP-2, 2560x1440@165, 0x0, 1, vrr, 3"
          "eDP-1, 1920x1080@240, 2560x360, 1.25"
        ])
        (lib.mkIf (!isGE66Raider) [
          ",preferred,auto,1"
        ])
      ];
      workspace = lib.mkIf isGE66Raider [
        "1,persistent:true,monitor:DP-2"
        "2,persistent:true,monitor:DP-2"
        "3,persistent:true,monitor:DP-2"
        "4,persistent:true,monitor:eDP-1"
        "5,persistent:true,monitor:eDP-1"
        "6,persistent:true,monitor:eDP-1"
      ];

      windowrule = [
        {
          name = "clipse-float";
          match.class = "clipse";
          float = "on";
          size = "652 652";
          stay_focused = "on";
          center = "on";
        }
        {
          name = "termfilechooser";
          match.class = "^(kitty)$";
          match.title = "^(Save File|Select Directory|Select File)$";
          float = "on";
          stay_focused = "on";
          size = "1200 800";
          center = "on";
        }
        {
          name = "steam-games";
          match.initial_class = "steam_app_.*";
          content = "game";
          fullscreen_state = "2 2";
          workspace = "2";
          no_max_size = "on";
          immediate = "on";
        }
        {
          name = "polkit-float";
          match.class = "^(polkit-gnome|polkit-kde|gcr-prompter)$";
          float = "on";
          size = "600 400";
          center = "on";
          stay_focused = "on";
        }
      ];

      exec-once = [
        "uwsm app -- clipse -listen"
        "uwsm app -- gnome-keyring-daemon --start --components=pkcs11,secrets"
        "uwsm app -- fcitx5 -d"
      ];
    };
  };
}
