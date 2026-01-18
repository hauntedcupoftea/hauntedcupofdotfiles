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
    ouch
    mediainfo
    imagemagick
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    plugins = {
      "full-border" = pkgs.yaziPlugins.full-border;
      "git" = pkgs.yaziPlugins.git;
      # "gitui" = pkgs.yaziPlugins.gitui; # doesn't work
      "mediainfo" = pkgs.yaziPlugins.mediainfo;
      "mount" = pkgs.yaziPlugins.mount;
      "ouch" = pkgs.yaziPlugins.ouch;
      "recycle-bin" = pkgs.yaziPlugins.recycle-bin;
      "starship" = pkgs.yaziPlugins.starship;
      # "wl-clipboard" = pkgs.yaziPlugins.wl-clipboard; # doesn't work
    };
    initLua = ''
      require("full-border"):setup()
      require("recycle-bin"):setup()
      require("starship"):setup()
      th.git = th.git or {}
      th.git.modified = ui.Style():fg("blue")
      th.git.deleted = ui.Style():fg("red"):bold()
      require("git"):setup {
        type = ui.Border.ROUNDED,
      }
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
      plugin.prepend_fetcher = [
        {
          id = "git";
          url = "*";
          run = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
        }
      ];
      plugin = {
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
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
          on = "<C-y>";
          run = ["plugin wl-clipboard"];
        }
        {
          on = ["R" "b"];
          run = ''plugin recycle-bin'';
          desc = "Open recycle bin";
        }
        {
          on = "M";
          run = "plugin mount";
        }
        {
          on = ["g" "i"];
          run = "plugin gitui";
          desc = "run gitui";
        }
        {
          on = ["C"];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
      ];
    };
  };
}
