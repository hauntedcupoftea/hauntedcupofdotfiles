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
  };

  config = lib.mkIf (hasDesktop && cfg.enable) {
    packages = [cfg.package];

    files.".config/wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm'
      local config = {}

      config.font = wezterm.font("${cfg.fontFamily}")
      config.font_size = ${toString cfg.fontSize}
      config.color_scheme_dirs = { wezterm.config_dir .. "/colors" }
      config.color_scheme = "wallust"
      config.window_decorations = "NONE"
      config.window_padding = {
        left = 1,
        right = 1,
        top = 0,
        bottom = 0
      }
      config.use_resize_increments = false
      config.window_background_opacity = 0.85
      config.default_prog = { "${fishPath}", "--login" }
      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = false
      config.use_fancy_tab_bar = true
      config.tab_max_width = 25

      config.scrollback_lines = 10000
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_rate = 500
      config.front_end = "WebGpu"
      config.webgpu_power_preference = "HighPerformance"

      config.disable_default_key_bindings = false
      config.keys = {
        -- Pane navigation (mirrors zellij pane mode: Ctrl+Alt+hjkl)
        { key = 'h', mods = 'CTRL|ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'CTRL|ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'CTRL|ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'CTRL|ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
        -- Splits (Alt+d horizontal, Alt+D vertical, like zellij Alt+n feel)
        { key = 'd', mods = 'ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'D', mods = 'ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
        -- Resize panes
        { key = 'h', mods = 'CTRL|ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
        { key = 'j', mods = 'CTRL|ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
        { key = 'k', mods = 'CTRL|ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
        { key = 'l', mods = 'CTRL|ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
        -- Tabs (zellij Ctrl+t n/p feel)
        { key = 'n', mods = 'CTRL|ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
        { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
        -- Close pane (zellij Ctrl+p x)
        { key = 'x', mods = 'CTRL|ALT', action = wezterm.action.CloseCurrentPane { confirm = true } },
        -- Command palette
        { key = '/', mods = 'CTRL', action = wezterm.action.ActivateCommandPalette },
        -- Reload config
        { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
      }

      return config
    '';
  };
}
