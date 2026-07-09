{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.desktop.wezterm;
  fishPath = lib.getExe pkgs.fish;
  hasDesktop = nixosConfig.dotfiles.desktop.enable or false;
in {
  options.dotfiles.desktop.wezterm = {
    enable = lib.mkEnableOption "WezTerm terminal emulator";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wezterm;
      description = "WezTerm package to use";
    };
    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 14.0;
      description = "Font size in points";
    };
    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "FiraCode Nerd Font Mono";
      description = "Primary font family";
    };
    leaderKey = lib.mkOption {
      type = lib.types.str;
      default = "Space";
      description = "Key used as the leader (combined with leaderMods)";
    };
    leaderMods = lib.mkOption {
      type = lib.types.str;
      default = "CTRL";
      description = "Modifier(s) for the leader key, e.g. CTRL or ALT|SUPER";
    };
    leaderTimeoutMs = lib.mkOption {
      type = lib.types.int;
      default = 1500;
      description = "Leader key timeout in milliseconds";
    };
  };

  config = lib.mkIf (hasDesktop && cfg.enable) {
    packages = [cfg.package];

    files.".config/wezterm/wezterm.lua".text =
      /*
      lua
      */
      ''
        local wezterm = require 'wezterm'
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        -- Performance
        config.max_fps = 240
        config.animation_fps = 240
        config.front_end = "WebGpu"
        config.webgpu_power_preference = "HighPerformance"

        -- Font
        config.font = wezterm.font_with_fallback{ "${cfg.fontFamily}", "Symbols Nerd Font Mono", "DejaVu Sans Mono" }
        config.font_size = ${toString cfg.fontSize}

        config.unicode_version = 14
        config.custom_block_glyphs = true

        -- Colors (wallust-generated scheme, read at runtime)
        config.color_scheme_dirs = { wezterm.config_dir .. "/colors" }
        config.color_scheme = "wallust"

        wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/wallust.toml")

        local function get_colors()
          local ok, scheme = pcall(function()
            return wezterm.color.get_builtin_schemes()["wallust"]
          end)
          if not ok or not scheme then
            return {
              background  = "#111111",
              foreground  = "#dddddd",
              cursor_bg   = "#cccccc",
              ansi        = { "#111111", "#cc6666", "#99cc99", "#f0c674",
                              "#81a2be", "#b294bb", "#8abeb7", "#c5c8c6" },
              brights     = { "#666666", "#d54e53", "#b9ca4a", "#e7c547",
                              "#7aa6da", "#c397d8", "#70c0b1", "#eaeaea" },
            }
          end
          return scheme
        end

        local cs = get_colors()

        local palette = {
          bg           = cs.background,
          fg           = cs.foreground or cs.brights[8],
          accent       = cs.ansi[5],      -- blue family
          leader_glyph = cs.ansi[6],      -- purple/mauve family
          active_tab   = cs.ansi[5],
          inactive_tab = cs.ansi[1] or cs.background,
          tab_text     = cs.background,
        }

        config.window_decorations = "NONE"
        config.window_padding = { left = 2, right = 2, top = 1, bottom = 1 }
        config.use_resize_increments = false
        config.window_background_opacity = 0.85

        -- Shell
        config.default_prog = { "${fishPath}", "--login" }

        -- Cursor
        config.default_cursor_style = 'BlinkingBlock'
        config.cursor_blink_rate = 500

        -- Scrollback
        config.scrollback_lines = 10000

        -- Tab bar
        config.enable_tab_bar = true
        config.hide_tab_bar_if_only_one_tab = false
        config.tab_bar_at_bottom = true
        config.use_fancy_tab_bar = false
        config.tab_max_width = 28

        config.tab_and_split_indices_are_zero_based = false

        local function tab_title(tab_info)
          local title = tab_info.tab_title
          if title and #title > 0 then return title end
          return tab_info.active_pane.title
        end

        wezterm.on("format-tab-title", function(tab, tabs, panes, cfg_, hover, max_width)
          local title = wezterm.truncate_right(tab_title(tab), max_width - 6)

          -- Active:   full fg text, accent-colored index prefix for hierarchy
          -- Inactive: considerably dimmed so the active tab pops cleanly
          -- Hover:    a nudge brighter than inactive but not full active
          local fg, index_fg
          if tab.is_active then
            fg       = palette.fg
            index_fg = palette.active_tab
          elseif hover then
            fg       = wezterm.color.parse(palette.fg):darken(0.15):to_string()
            index_fg = fg
          else
            fg       = wezterm.color.parse(palette.fg):darken(0.45):to_string()
            index_fg = wezterm.color.parse(palette.active_tab):darken(0.45):to_string()
          end

          return {
            { Background = { Color = palette.bg } },
            { Foreground = { Color = index_fg } },
            { Text = "  " .. (tab.tab_index + 1) .. " " },
            { Foreground = { Color = fg } },
            { Text = title .. "  " },
          }
        end)

        -- Leader key
        config.leader = {
          key = "${cfg.leaderKey}",
          mods = "${cfg.leaderMods}",
          timeout_milliseconds = ${toString cfg.leaderTimeoutMs},
        }

        -- Keybindings
        --   Tabs   → t (new), b/f (prev/next), 1-9 (direct)
        --   Panes  → n (horiz split, zellij feel), N (vert split)
        --            hjkl (navigate), HJKL (resize), x (close)
        --   Misc   → / (command palette), r (reload config), p (pane zoom toggle)

        config.disable_default_key_bindings = false
        config.keys = {
          { key = "t", mods = "LEADER",
            action = wezterm.action.SpawnTab "CurrentPaneDomain" },
          { key = "b", mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(-1) },
          { key = "f", mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(1) },
          { key = "x", mods = "LEADER",
            action = wezterm.action.CloseCurrentPane { confirm = true } },
          { key = "n", mods = "LEADER",
            action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
          { key = "N", mods = "LEADER",
            action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
          { key = "h", mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Left" },
          { key = "j", mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Down" },
          { key = "k", mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Up" },
          { key = "l", mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Right" },
          { key = "H", mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Left", 5 } },
          { key = "J", mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Down", 5 } },
          { key = "K", mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Up", 5 } },
          { key = "L", mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Right", 5 } },
          { key = "p", mods = "LEADER",
            action = wezterm.action.TogglePaneZoomState },
          { key = "/", mods = "LEADER",
            action = wezterm.action.ActivateCommandPalette },
          { key = "r", mods = "LEADER",
            action = wezterm.action.ReloadConfiguration },
        }
        for i = 1, 9 do
          table.insert(config.keys, {
            key = tostring(i),
            mods = "LEADER",
            action = wezterm.action.ActivateTab(i - 1),
          })
        end

        wezterm.on("update-status", function(window, _)
          if window:leader_is_active() then
            window:set_left_status(wezterm.format {
              { Foreground = { Color = palette.bg } },
              { Background = { Color = palette.leader_glyph } },
              { Attribute = { Intensity = "Bold" } },
              { Text = " WAIT " },
              { Attribute = { Intensity = "Normal" } },
            })
          else
            window:set_left_status ""
          end
        end)

        return config
      '';
  };
}
