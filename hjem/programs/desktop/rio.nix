{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.rio;
in {
  options.dotfiles.desktop.rio.enable =
    lib.mkEnableOption "rio terminal emulator";

  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    packages = [pkgs.rio];

    files.".config/rio/config.toml".source = (pkgs.formats.toml {}).generate "rio.toml" {
      theme = "wallust";

      confirm-before-quit = false;
      scrollback-history-limit = 10000;
      enable-scroll-bar = true;
      line-height = 1.0;
      hide-mouse-cursor-when-typing = true;

      shell = {
        program = lib.getExe pkgs.fish;
        args = ["--login"];
      };

      editor.program = lib.getExe pkgs.helix;

      cursor = {
        shape = "block";
        blinking = true;
        blinking-interval = 800;
      };

      fonts = {
        family = "FiraCode Nerd Font";
        size = 14.0;
        use-drawable-chars = true;
        # ligatures tracked at https://github.com/raphamorim/rio/issues/310
        features = [];
        disable-warnings-not-found = false;
      };

      scroll = {
        multiplier = 3.0;
        divider = 1.0;
      };

      navigation = {
        mode = "Plain"; # using zellij for multiplexing
        use-split = false;
      };

      window = {
        opacity = 0.85;
        blur = true;
        decorations = "Enabled";
        mode = "Maximized";
        opacity-cells = false; # keeps TUI surfaces (helix, zellij) opaque
      };

      renderer = {
        disable-unfocused-render = true; # saves GPU when backgrounded
        strategy = "events";
      };
    };
  };
}
