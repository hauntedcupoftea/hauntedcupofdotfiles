{
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.environments.hyprland;
  monitors = nixosConfig.dotfiles.desktop.monitors or [];

  monitorLines =
    if monitors == []
    then ''
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
    ''
    else
      lib.concatMapStrings (m: ''
        hl.monitor({
          output = "${m.name}",
          mode = "${m.resolution}@${toString m.refreshRate}",
          position = "${m.position}",
          scale = ${toString m.scale},
          ${lib.optionalString m.vrr "vrr = true,"}
          ${lib.optionalString m.hdr "bitdepth = 10,"}
        })
      '')
      monitors;

  primaryMonitor = lib.findFirst (m: m.primary) null monitors;
  secondaryMonitors = lib.filter (m: !m.primary) monitors;
  orderedMonitors = lib.optional (primaryMonitor != null) primaryMonitor ++ secondaryMonitors;
  workspaceRuleLines = lib.concatStrings (
    lib.imap0 (
      monitorIndex: m:
        lib.concatMapStrings (
          localWs: let
            globalWs = monitorIndex * 4 + localWs;
          in ''
            hl.workspace_rule({ workspace = "${toString globalWs}", persistent = true, monitor = "${m.name}" })
          ''
        ) [1 2 3 4]
    )
    orderedMonitors
  );
in {
  options.dotfiles.environments.hyprland = {
    enable = lib.mkEnableOption "hyprland configuration";
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Terminal emulator command for keybinds and floating windows.";
    };
  };

  config = lib.mkIf cfg.enable {
    rum.desktops.hyprland.enable = true;

    files.".config/hypr/hyprland.lua".text =
      /*
      lua
      */
      ''
        ${monitorLines}

        ${workspaceRuleLines}

        local terminal = "${cfg.terminal}"
        local mod = "SUPER"
        local altMod = "SUPER+SHIFT"

        hl.env("XCURSOR_SIZE", "24")
        hl.env("HYPRCURSOR_SIZE", "24")

        hl.config({
          general = {
            gaps_in = 6,
            gaps_out = 8,
            border_size = 2,
            resize_on_border = true,
            allow_tearing = false,
            layout = "dwindle",
          },
          decoration = {
            rounding = 8,
            rounding_power = 2,
            active_opacity = 1.0,
            inactive_opacity = 0.95,
            shadow = {
              enabled = true,
              range = 6,
              render_power = 3,
              color = 0xcc000000,
            },
            blur = {
              enabled = true,
              size = 4,
              passes = 2,
              vibrancy = 0.17,
              new_optimizations = true,
            },
          },
          animations = { enabled = true },
          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            focus_on_activate = true,
            force_default_wallpaper = 0,
            session_lock_xray = true,
            vrr = 3,
          },
          dwindle = {
            preserve_split = true,
            smart_split = false,
          },
          input = {
            follow_mouse = 1,
            sensitivity = 0,
            touchpad = {
              natural_scroll = true,
              tap_to_click = true,
            },
          },
        })

        hl.curve("easeOutQuint",    { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
        hl.curve("easeInOutCubic",  { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
        hl.curve("almostLinear",    { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
        hl.curve("quick",           { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

        hl.animation({ leaf = "global",         enabled = true, speed = 10,   bezier = "default" })
        hl.animation({ leaf = "windows",        enabled = true, speed = 4.79, bezier = "easeOutQuint" })
        hl.animation({ leaf = "windowsIn",      enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
        hl.animation({ leaf = "windowsOut",     enabled = true, speed = 1.49, bezier = "quick",        style = "popin 87%" })
        hl.animation({ leaf = "fade",           enabled = true, speed = 3.03, bezier = "quick" })
        hl.animation({ leaf = "fadeIn",         enabled = true, speed = 1.73, bezier = "almostLinear" })
        hl.animation({ leaf = "fadeOut",        enabled = true, speed = 1.46, bezier = "almostLinear" })
        hl.animation({ leaf = "layers",         enabled = true, speed = 3.81, bezier = "easeOutQuint" })
        hl.animation({ leaf = "layersIn",       enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
        hl.animation({ leaf = "layersOut",      enabled = true, speed = 1.5,  bezier = "quick",        style = "fade" })
        -- hl.animation({ leaf = "workspaces",     enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

        -- Autostart: things that explicitly need Hyprland
        hl.on("hyprland.start", function()
          hl.exec_cmd("uwsm app -- fcitx5 -d")
          hl.exec_cmd("uwsm app -- gnome-keyring-daemon --start --components=pkcs11,secrets")
          hl.exec_cmd("uwsm app -- clipse -listen")
        end)

        -- Keybinds
        hl.bind(mod .. " + return",   hl.dsp.exec_cmd("uwsm app -- " .. terminal))
        hl.bind(mod .. " + Q",        hl.dsp.window.close())
        hl.bind(mod .. " + B",        hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mod .. " + F",        hl.dsp.window.fullscreen())
        hl.bind(mod .. " + P",        hl.dsp.window.pin())
        hl.bind(mod .. " + space",    hl.dsp.exec_cmd("nc -U $XDG_RUNTIME_DIR/walker/walker.sock"))
        hl.bind(mod .. " + Z",        hl.dsp.exec_cmd("uwsm app -- zen-twilight"))
        hl.bind(mod .. " + E",        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e --class yazi yazi"))
        hl.bind(mod .. " + V",        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e --class clipse clipse"))
        hl.bind(altMod .. " + C",     hl.dsp.exec_cmd("uwsm app -- hyprpicker -a"))

        -- Focus movement
        hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
        hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
        hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

        -- Screenshots
        hl.bind("Print",              hl.dsp.exec_cmd("uwsm app -- grimblast copy area --notify"))
        hl.bind(altMod .. " + Print", hl.dsp.exec_cmd("uwsm app -- hyprshot -m region --clipboard-only"))
        hl.bind(mod .. " + Print",    hl.dsp.exec_cmd("uwsm app -- hyprshot -m output"))

        -- Special workspace
        hl.bind(mod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
        hl.bind(altMod .. " + S",    hl.dsp.window.move({ workspace = "special:magic" }))

        -- Workspace switching: numrow + letter aliases
        local keymap = { "m", "comma", "period", "slash", "j", "k", "l", "semicolon", "u", "i", "o", "p" }

        for i, key in ipairs(keymap) do
            hl.bind(mod .. " + " .. key,        hl.dsp.focus({ workspace = i }))
            hl.bind(altMod .. " + " .. key,     hl.dsp.window.move({ workspace = i }))
        end

        for i = 1, 9 do
            hl.bind(mod .. " + " .. i,      hl.dsp.focus({ workspace = i }))
            hl.bind(altMod .. " + " .. i,   hl.dsp.window.move({ workspace = i }))
        end

        -- Mouse workspace scroll
        hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
        hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

        -- Move/resize with mouse
        hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Media/brightness
        hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
        hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true })
        hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true })
        hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })
        hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),        { locked = true })
        hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),   { locked = true })
        hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),   { locked = true })
        hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),     { locked = true })

        -- Window rules
        hl.window_rule({
          name = "suppress-maximize",
          match = { class = ".*" },
          suppress_event = "maximize",
        })

        hl.window_rule({
          name = "fix-xwayland-drags",
          match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
          no_focus = true,
        })

        hl.window_rule({
          name = "clipse-float",
          match = { class = "clipse" },
          float = true,
          size = "652 652",
          stay_focused = true,
          center = true,
        })

        hl.window_rule({
          name = "termfilechooser",
          match = { class = "^(kitty|rio|wezterm)$", title = "^(Save File|Select Directory|Select File)$" },
          float = true,
          stay_focused = true,
          size = "1200 800",
          center = true,
        })

        hl.window_rule({
          name = "steam-games",
          match = { initial_class = "steam_app_.*" },
          content = "game",
          fullscreen_state = "2 2",
          workspace = "2",
          no_max_size = true,
          immediate = true,
        })

        hl.window_rule({
          name = "steam-games-wayland",
          match = { xdg_tag = "proton-game" },
          content = "game",
          fullscreen_state = "2 2",
          workspace = "2",
          no_max_size = true,
          immediate = true,
        })

        hl.window_rule({
          name = "polkit-float",
          match = { class = "^(polkit-gnome|polkit-kde|gcr-prompter)$" },
          float = true,
          size = "600 400",
          center = true,
          stay_focused = true,
        })

        hl.window_rule({
          name = "waydroid-phone",
          match = { class = "^(Waydroid)$" },
          float = true,
          size = "405 877",
          center = true,
        })
      '';
  };
}
