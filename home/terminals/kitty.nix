{ pkgs
, ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      background_opacity = "0.95";
      shell = "${pkgs.fish}/bin/fish";
      tab_bar_style = "hidden";
      window_padding_width = "1 2";
    };
    shellIntegration.enableFishIntegration = true;
  };

  home.sessionVariables = {
    TERM = "kitty";
  };
}
