{pkgs, ...}: {
  home.packages = [pkgs.zellij];
  programs.zellij = {
    enable = true;

    # This is crucial for automatically starting Zellij when Fish launches.
    # It typically adds the necessary auto-start script to your Fish config.
    enableFishIntegration = true;

    # Optional: If true, Zellij will try to attach to an existing session
    # when auto-started. If no session exists, it will create a new one.
    attachExistingSession = true;

    # Optional: If true, your shell will exit when Zellij exits
    # after being auto-started.
    exitShellOnExit = true;

    # Zellij settings (written to $XDG_CONFIG_HOME/zellij/config.kdl)
    settings = {
      default_shell = "fish";
      theme = "catppuccin-mocha";

      # Other Zellij options you might want:
      # default_layout = "compact";
      # mouse_mode = false; # Useful if you prefer terminal's native mouse handling
      # simplified_ui = true; # If you prefer a cleaner look

      # Example of adding a keybinding (check Zellij docs for syntax)
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
