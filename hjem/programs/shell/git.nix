{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.git;
in {
  options.dotfiles.shell.git = {
    enable = lib.mkEnableOption "git";

    userName = lib.mkOption {
      type = lib.types.str;
      description = "Git commit author name.";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "Git commit author email.";
    };

    github.enable = lib.mkEnableOption "GitHub CLI and config (gh, defaultBranch = main)";

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra settings merged into rum.programs.git.settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs;
      [gitui]
      ++ lib.optional cfg.github.enable gh;

    rum.programs.git = {
      enable = true;
      settings = lib.mkMerge [
        {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
          init.defaultBranch = if cfg.github.enable then "main" else "master";
          pull.rebase = true;
          push.autoSetupRemote = true;
        }
        cfg.extraConfig
      ];
    };
  };
}
