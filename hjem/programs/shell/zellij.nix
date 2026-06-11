{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.shell.zellij;
  fishOn = config.dotfiles.shell.fish.enable;
  isDesktop = nixosConfig.dotfiles.desktop.enable or false;
in {
  options.dotfiles.shell.zellij = {
    enable = lib.mkEnableOption "zellij terminal multiplexer";
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = isDesktop;
      description = "Auto-start zellij when an interactive fish session opens.";
    };
    attachExistingSession = lib.mkOption {
      type = types.bool;
      default = false;
      description = "making this true will attach new terminal sessions to existing zellij ones";
    };
    exitOnSessionExit = lib.mkOption {
      type = types.bool;
      default = false;
      description = "making this true will kill terminal session when zellij is exited";
    };
    sshOnly = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Only auto-start zellij when the session is over SSH (i.e., $SSH_TTY is set).
        Useful when you want a different multiplexer locally but zellij on remote hosts.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    packages = [pkgs.zellij];
    environment.sessionVariables = {
      ZELLIJ_AUTO_EXIT =
        if cfg.exitOnSessionExit
        then "true"
        else "false";
      ZELLIJ_AUTO_ATTACH =
        if cfg.attachExistingSession
        then "true"
        else "false";
    };
    files.".config/zellij/config.kdl".text = ''
      default_shell "fish"
      show_startup_tips false
      theme_dir "${config.directory}/.config/zellij/themes"
      theme "wallust"
      ui {
        pane_frames {
          hide_session_name true
          rounded_corners true
        }
      }
    '';
    rum.programs.fish.config = lib.mkIf (fishOn && (cfg.autoStart || cfg.sshOnly)) ''
      if status is-interactive
        ${
        if cfg.sshOnly
        then ''
          if set -q SSH_TTY
            eval (zellij setup --generate-auto-start fish | string collect)
          end
        ''
        else ''
          eval (zellij setup --generate-auto-start fish | string collect)
        ''
      }
      end
    '';
  };
}
