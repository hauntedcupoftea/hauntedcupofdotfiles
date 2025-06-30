{ pkgs, ... }: {
  home.packages = [ pkgs.zellij ];
  programs.zellij = {
    enable = true;
    enableFishIntegration = true; # disable if using bash
    attachExistingSession = false;
    exitShellOnExit = true; # close shell on <C-d> zellij

    # Zellij settings (written to $XDG_CONFIG_HOME/zellij/config.kdl)
    settings = {
      default_shell = "fish";
      theme = "catppuccin-mocha";
      show_startup_tips = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
          rounded_corners = true;
        };
      };

      # other (potentially useful) settings
      # default_layout = "compact";
      # mouse_mode = false; # useful if you prefer terminal's native mouse handling
      # simplified_ui = true; # if you prefer a cleaner look
      # keybinds = {
      #   shared = {
      #     "Ctrl o" = [ { "SwitchToMode" = "Locked"; } ];
      #   };
      #   normal = {
      #     bind "Alt n" { NewPane; };
      #   };
      # };
    };
  };
}
