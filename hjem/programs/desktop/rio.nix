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
    packages = [
      pkgs.rio
    ];

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

      editor.program = "nvim";

      cursor = {
        shape = "block";
        blinking = true;
        blinking-interval = 800;
      };

      fonts = {
        family = "FiraCode Nerd Font";
        size = 18.0;
        use-drawable-chars = true;
        # ligatures tracked at https://github.com/raphamorim/rio/issues/310
        features = [];
        disable-warnings-not-found = false;
        extras = [
          {family = "Noto Sans Mono CJK SC";}
          {family = "Noto Sans Mono CJK KR";}
          {family = "Noto Sans Mono CJK JP";}
        ];
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
        mode = "Windowed";
        opacity = 0.80;
        blur = true;
        decorations = "Enabled";
        opacity-cells = false;
      };

      renderer = {
        backend = "Webgpu";
        strategy = "events";
        target-fps = 165;
      };
    };
  };
}
