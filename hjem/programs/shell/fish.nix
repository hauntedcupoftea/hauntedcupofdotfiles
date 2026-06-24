{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.fish;
in {
  options.dotfiles.shell.fish = {
    enable = lib.mkEnableOption "fish shell";

    shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shell aliases merged into rum.programs.fish.shellAliases.";
    };

    shellInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra fish shell initialisation lines.";
    };

    vim-mode = {
      enable = lib.mkEnableOption "fish shell vim-mode";

      default-mode = lib.mkOption {
        type = lib.types.enum ["insert" "default" "visual"];
        default = "insert";
        description = "The starting mode for each shell prompt. defaults to insert mode.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    rum.programs.fish = {
      enable = true;

      aliases = lib.mkMerge [
        (lib.mkIf (!config.dotfiles.shell.eza.enable) {
          ll = "ls -la";
        })
        {
          update = "sudo nixos-rebuild switch";
          nix-gc = "sudo nix-collect-garbage -d";
        }
        cfg.shellAliases
      ];

      config = lib.concatStringsSep "\n" [
        ''
          set fish_greeting # disable greeting
          bind \cz 'fg 2>/dev/null; commandline -f repaint'
        ''
        cfg.shellInit
        (
          lib.optionalString (cfg.vim-mode.enable)
          ''
            function fish_vi_bindings
                fish_vi_key_bindings ${cfg.vim-mode.default-mode}
            end

            set -g fish_key_bindings fish_vi_bindings
          ''
        )
      ];

      functions.y = ''
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
