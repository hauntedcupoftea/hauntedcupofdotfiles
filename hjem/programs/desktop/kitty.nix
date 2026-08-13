{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.kitty;
  leaderPrefix = "ctrl+space";
in {
  options.dotfiles.desktop.kitty.enable =
    lib.mkEnableOption "kitty terminal emulator";
  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    rum.programs.kitty = {
      enable = true;
      integrations.fish.enable = config.dotfiles.shell.fish.enable;
      settings = {
        include = "colors.conf"; # theming
        scrollback_lines = 10000;
        enable_audio_bell = true;
        window_alert_on_bell = true;
        update_check_interval = 0;
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
        cursor_trail = 2;
        cursor_trail_start_threshold = 1;
        cursor_trail_decay = "0.1 0.4";

        # Layouts needed for splits and the pane-zoom toggle
        enabled_layouts = "splits,stack";

        # Tab bar: bottom edge, numbered tabs, inactive tabs faded automatically
        tab_bar_edge = "bottom";
        tab_bar_style = "fade";
        tab_bar_min_tabs = 1;
        tab_title_template = "{index}: {title}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";

        # Keybindings, leader-style via kitty's key-sequence syntax
        #   Tabs   -> t (new), b/f (prev/next), 1-9 (direct)
        #   Panes  -> n (horiz split), N (vert split), hjkl (navigate),
        #             HJKL (resize), x (close), p (zoom toggle)
        #   Misc   -> r (reload config)
        map = [
          "${leaderPrefix}>t new_tab_with_cwd"
          "${leaderPrefix}>b previous_tab"
          "${leaderPrefix}>f next_tab"
          "${leaderPrefix}>1 goto_tab 1"
          "${leaderPrefix}>2 goto_tab 2"
          "${leaderPrefix}>3 goto_tab 3"
          "${leaderPrefix}>4 goto_tab 4"
          "${leaderPrefix}>5 goto_tab 5"
          "${leaderPrefix}>6 goto_tab 6"
          "${leaderPrefix}>7 goto_tab 7"
          "${leaderPrefix}>8 goto_tab 8"
          "${leaderPrefix}>9 goto_tab 9"

          "${leaderPrefix}>n launch --location=hsplit --cwd=current"
          "${leaderPrefix}>shift+n launch --location=vsplit --cwd=current"
          "${leaderPrefix}>h neighboring_window left"
          "${leaderPrefix}>j neighboring_window bottom"
          "${leaderPrefix}>k neighboring_window top"
          "${leaderPrefix}>l neighboring_window right"
          "${leaderPrefix}>shift+h resize_window narrower 5"
          "${leaderPrefix}>shift+j resize_window shorter 5"
          "${leaderPrefix}>shift+k resize_window taller 5"
          "${leaderPrefix}>shift+l resize_window wider 5"
          "${leaderPrefix}>x close_window"
          "${leaderPrefix}>p toggle_layout stack"

          "${leaderPrefix}>r load_config_file"
        ];
      };
    };
  };
}
