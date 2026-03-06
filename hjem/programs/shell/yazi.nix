{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.yazi;
  fishOn = config.dotfiles.shell.fish.enable;
in {
  options.dotfiles.shell.yazi.enable =
    lib.mkEnableOption "yazi terminal file manager";

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [
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
    ];

    rum.programs.yazi = {
      enable = cfg.enable;
      settings = {
        mgr.linemode = "size";
        opener.edit = [
          {
            run = ''hx "$@"'';
            block = true;
            desc = "Helix";
          }
        ];
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
        plugin.prepend_previewers = [
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
        plugin.prepend_preloaders = [
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
      keymap.mgr.prepend_keymap = [
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
          run = "plugin recycle-bin";
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

    # plugins and init.lua not in rum — manage via files
    files.".config/yazi/plugins/full-border.yazi".source = "${pkgs.yaziPlugins.full-border}";
    files.".config/yazi/plugins/git.yazi".source = "${pkgs.yaziPlugins.git}";
    files.".config/yazi/plugins/mediainfo.yazi".source = "${pkgs.yaziPlugins.mediainfo}";
    files.".config/yazi/plugins/mount.yazi".source = "${pkgs.yaziPlugins.mount}";
    files.".config/yazi/plugins/ouch.yazi".source = "${pkgs.yaziPlugins.ouch}";
    files.".config/yazi/plugins/recycle-bin.yazi".source = "${pkgs.yaziPlugins.recycle-bin}";
    files.".config/yazi/plugins/starship.yazi".source = "${pkgs.yaziPlugins.starship}";

    files.".config/yazi/init.lua".text = ''
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

    # y() wrapper
    rum.programs.fish.functions = lib.mkIf fishOn {
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };
}
