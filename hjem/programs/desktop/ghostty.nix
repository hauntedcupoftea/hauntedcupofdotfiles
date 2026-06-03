{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.ghostty;
in {
  options.dotfiles.desktop.ghostty.enable =
    lib.mkEnableOption "ghostty terminal emulator";

  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    packages = [pkgs.ghostty];

    files.".config/ghostty/config.ghostty".text = ''
      command = ${lib.getExe pkgs.fish} --login

      font-family = FiraCode Nerd Font
      font-size = 14
      font-feature = ss01
      font-feature = ss02
      font-feature = ss03
      font-feature = ss04
      font-feature = ss05
      font-feature = ss06
      font-feature = ss07
      font-feature = cv16
      font-codepoint-map = U+4E00-U+9FFF=Noto Sans Mono CJK SC
      font-codepoint-map = U+AC00-U+D7AF=Noto Sans Mono CJK KR
      font-codepoint-map = U+3040-U+30FF=Noto Sans Mono CJK JP

      # Cursor
      cursor-style = block
      cursor-style-blink = true
      mouse-hide-while-typing = true

      # Window
      background-opacity = 0.80
      background-blur = true
      window-decoration = true

      # Scrollback
      scrollback-limit = 10000

      # Behaviour
      confirm-close-surface = false

      shell-integration = detect
      shell-integration-features = cursor,title,sudo

      theme = wallust
    '';
  };
}
