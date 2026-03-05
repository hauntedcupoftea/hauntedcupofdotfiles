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
  };

  config = lib.mkIf cfg.enable {
    rum.programs.fish = {
      enable = true;

      aliases = lib.mkMerge [
        {
          ll = "ls -la";
          update = "sudo nixos-rebuild switch";
          nix-gc = "sudo nix-collect-garbage -d";
        }
        cfg.shellAliases
      ];

      config = lib.mkMerge [
        ''
          set fish_greeting # disable greeting
          bind \cz 'fg 2>/dev/null; commandline -f repaint'

          if status is-interactive
              eval (zellij setup --generate-auto-start fish | string collect)
          end
        ''
        cfg.shellInit
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
