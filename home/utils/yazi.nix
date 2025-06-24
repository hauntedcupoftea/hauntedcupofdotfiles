{ pkgs, ... }: {
  home.packages = with pkgs; [
    yazi
    ffmpeg
    p7zip
    jq
    poppler
    fd
    ripgrep
    # fzf
    # zoxide
    imagemagick
    dragon-drop
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        linemode = "size";
      };
    };
    keymap = {
      mgr.prepend_keymap = [{
        on = "<C-n>";
        run = ''shell -- dragon-drop -x -i -T "$1"'';
      }];
    };
  };
}
