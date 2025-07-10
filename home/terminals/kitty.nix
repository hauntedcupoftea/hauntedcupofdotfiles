{ pkgs
, ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 13;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = true;
      update_check_interval = 0;
      background_opacity = "0.95";
      shell = "${pkgs.fish}/bin/fish";
      tab_bar_style = "hidden";
      window_padding_width = "1 2";
    };
    shellIntegration.enableFishIntegration = true;
  };

  catppuccin.kitty.enable = true;

  home.sessionVariables = {
    TERM = "kitty";
  };
}
