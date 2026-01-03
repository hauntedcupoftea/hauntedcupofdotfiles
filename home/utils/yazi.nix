{pkgs, ...}: {
  home.packages = with pkgs; [
    yazi
    ffmpeg
    p7zip
    jq
    poppler
    fd
    ripgrep
    imagemagick
    dragon-drop
    trash-cli
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    plugins = {
      "recycle-bin" = pkgs.yaziPlugins.recycle-bin;
    };
    initLua = ''
      require("recycle-bin"):setup()
    '';
    settings = {
      mgr = {
        linemode = "size";
      };
      opener = {
        edit = [
          {
            run = ''hx "$@"'';
            block = true;
            desc = "Helix";
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-n>";
          run = ''shell -- dragon-drop -x -i -T "$1"'';
          desc = "Drag and drop selected files";
        }
        {
          on = ["R" "b"];
          run = ''plugin recycle-bin'';
          desc = "Open recycle bin";
        }
      ];
    };
  };

  # catppuccin.yazi.enable = true;
}
