{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.kitty;
in {
  options.dotfiles.desktop.kitty = {
    enable = lib.mkEnableOption "kitty terminal emulator";
    leaderPrefix = lib.mkOption {
      type = lib.types.str;
      default = "ctrl+space";
      description = "kitty terminal's leader keybind prefix.";
    };
  };
  config = lib.mkIf (osConfig.dotfiles.desktop.enable && cfg.enable) {
    rum.programs.kitty = {
      enable = true;
      integrations.fish.enable = config.dotfiles.shell.fish.enable;
      settings = {
        include = "colors.conf"; # theming
        scrollback_lines = 10000;
        enable_audio_bell = true;
        window_alert_on_bell = true;
        update_check_interval = 1;
        shell = lib.getExe pkgs.fish;
        window_padding_width = "1 2";
        font_size = "14.0";
        font_family = "FiraCode Nerd Font";
        background_opacity = "0.85";
        background_blur = 1;

        # Cursor, to mirror the WezTerm blinking block
        cursor_shape = "block";
        cursor_blink_interval = "0.5";

        # Cursor trail, Contour-style
        cursor_trail = 3;
        cursor_trail_start_threshold = 2;
        cursor_trail_decay = "0.1 0.4";

        enabled_layouts = "splits,stack";
        text_composition_strategy = "platform";

        tab_bar_edge = "bottom";
        tab_bar_style = "fade";
        tab_bar_min_tabs = 1;
        tab_title_template = "{index}: {title}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";

        repaint_delay = "8";
        input_delay = "2";
        sync_to_monitor = "yes";

        bell_on_tab = " ";

        # Keybindings, leader-style via kitty's key-sequence syntax
        #   Tabs   -> t (new), b/f (prev/next), 1-9 (direct)
        #   Panes  -> n (horiz split), N (vert split), hjkl (navigate),
        #             HJKL (resize), x (close), p (zoom toggle)
        #   Misc   -> r (reload config)
        map = [
          "${cfg.leaderPrefix}>t new_tab_with_cwd"
          "${cfg.leaderPrefix}>b previous_tab"
          "${cfg.leaderPrefix}>f next_tab"
          "${cfg.leaderPrefix}>1 goto_tab 1"
          "${cfg.leaderPrefix}>2 goto_tab 2"
          "${cfg.leaderPrefix}>3 goto_tab 3"
          "${cfg.leaderPrefix}>4 goto_tab 4"
          "${cfg.leaderPrefix}>5 goto_tab 5"
          "${cfg.leaderPrefix}>6 goto_tab 6"
          "${cfg.leaderPrefix}>7 goto_tab 7"
          "${cfg.leaderPrefix}>8 goto_tab 8"
          "${cfg.leaderPrefix}>9 goto_tab 9"

          "${cfg.leaderPrefix}>n launch --location=hsplit --cwd=current"
          "${cfg.leaderPrefix}>m launch --location=vsplit --cwd=current"
          "${cfg.leaderPrefix}>= layout_action equalize"
          "${cfg.leaderPrefix}>h neighboring_window left"
          "${cfg.leaderPrefix}>j neighboring_window bottom"
          "${cfg.leaderPrefix}>k neighboring_window top"
          "${cfg.leaderPrefix}>l neighboring_window right"
          "${cfg.leaderPrefix}>shift+h resize_window narrower 5"
          "${cfg.leaderPrefix}>shift+j resize_window shorter 5"
          "${cfg.leaderPrefix}>shift+k resize_window taller 5"
          "${cfg.leaderPrefix}>shift+l resize_window wider 5"
          "${cfg.leaderPrefix}>= layout_action equalize"
          "${cfg.leaderPrefix}>q close_window"
          "${cfg.leaderPrefix}>p toggle_layout stack"
          "${cfg.leaderPrefix}>u open_url_with_hints"
          "${cfg.leaderPrefix}>f kitten hints --type path --program firefox"
          "${cfg.leaderPrefix}>c kitten hints --type hash --program @"
          "${cfg.leaderPrefix}>e start_resizing_window"

          "${cfg.leaderPrefix}>r load_config_file"

          "ctrl+shift+c copy_to_clipboard"
          "ctrl+shift+v paste_from_clipboard"
        ];
      };
    };
  };
}
