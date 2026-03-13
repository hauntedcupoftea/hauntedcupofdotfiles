{
  config,
  lib,
  nixosConfig,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.environments.hyprland;
  qs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  monitors = nixosConfig.dotfiles.desktop.monitors;
  monitorStrings =
    if monitors == []
    then [",preferred,auto,1"]
    else map (m: "${m.name}, ${m.resolution}@${toString m.refreshRate}, ${m.position}, ${toString m.scale}${lib.optionalString m.vrr ", vrr, 2"}") monitors;

  primaryMonitor = lib.findFirst (m: m.primary) null monitors;
  secondaryMonitors = lib.filter (m: !m.primary) monitors;
  workspaceRules = lib.optionals (primaryMonitor != null) (
    map (i: "${toString i},persistent:true,monitor:${primaryMonitor.name}") [1 2 3]
    ++ lib.concatMap (
      m:
        map (i: "${toString i},persistent:true,monitor:${m.name}") [4 5 6]
    )
    secondaryMonitors
  );

  terminal =
    if config.dotfiles.desktop.kitty.enable
    then "kitty"
    else if config.dotfiles.desktop.rio.enable
    then "rio"
    else "kitty";
in {
  options.dotfiles.environments.hyprland = {
    enable = lib.mkEnableOption "tea's hyprland configuration";
    quickshellConfigPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to quickshell config directory";
    };
  };

  config = lib.mkIf cfg.enable {
    rum.desktops.hyprland = {
      enable = true;
      settings = {
        "$terminal" = terminal;
        "$mod" = "SUPER";
        "$altMod" = "SUPER_SHIFT";

        general = {
          gaps_in = 6;
          gaps_out = "8";
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
          force_default_wallpaper = 0;
          vrr = 3;
        };

        decoration.rounding = 8;

        monitor = monitorStrings;
        workspace = lib.mkIf (workspaceRules != []) workspaceRules;

        bind =
          [
            "$mod, return, exec, uwsm app -- $terminal"
            "$mod, Q, killactive"
            "$mod, B, togglefloating"
            "$mod, F, fullscreen"
            "$mod, P, pin"
            "$mod, V, exec, uwsm app -- $terminal --class clipse -e 'clipse'"
            "$mod, space, exec, uwsm app -- walker"
            "$mod, h, movefocus, l"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"
            "$mod, l, movefocus, r"
            "$mod, Z, exec, uwsm app -- zen-twilight"
            "$mod, E, exec, uwsm app -- $terminal -e yazi"
            ", Print, exec, uwsm app -- grimblast copy area --notify"
            "$altMod, PRINT, exec, uwsm app -- hyprshot -m region --clipboard-only"
            "SUPER, PRINT, exec, uwsm app -- hyprshot -m output"
            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"
            "$mod, mouse_down, workspace, e-1"
            "$mod, mouse_up, workspace, e+1"
            "$altMod, c, exec, uwsm app -- hyprpicker -a"
          ]
          ++ (
            let
              keymap = ["m" "comma" "period" "j" "k" "l" "u" "i" "o"];
            in
              builtins.concatLists (builtins.genList (i: let
                  ws = i + 1;
                  key = builtins.elemAt keymap i;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                  "$mod, ${key}, workspace, ${toString ws}"
                  "$mod SHIFT, ${key}, movetoworkspace, ${toString ws}"
                ])
                9)
          );

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

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
            match.class = "^(kitty|rio)$";
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
          {
            name = "waydroid-phone";
            match.class = "^(Waydroid)$";
            float = "on";
            size = "405 877";
            center = "on";
          }
        ];

        exec-once =
          [
            "uwsm app -- clipse -listen"
            "uwsm app -- gnome-keyring-daemon --start --components=pkcs11,secrets"
            "uwsm app -- fcitx5 -d"
          ]
          ++ lib.optional (cfg.quickshellConfigPath != null)
          "uwsm app -- ${lib.getExe qs} -p ${cfg.quickshellConfigPath}";
      };
    };
  };
}
