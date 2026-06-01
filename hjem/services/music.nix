{
  config,
  lib,
  pkgs,
  nixosConfig ? {}, # passed via specialArgs, contains host config
  ...
}: let
  cfg = config.dotfiles.services.music;
  home = config.directory;
  xdgConfig = config.xdg.config.directory;
  xdgData = config.xdg.data.directory;
  hasDesktop = nixosConfig.dotfiles.desktop.enable or false;
  hyprlandOn = config.dotfiles.environments.hyprland.enable;

  musicDir =
    if cfg.mpd.musicDirectory != null
    then cfg.mpd.musicDirectory
    else "${home}/Music";
  dataDir = cfg.mpd.dataDir or "${xdgData}/mpd";
  playlistDir = cfg.mpd.playlistDirectory or "${dataDir}/playlists";
  dbFile = cfg.mpd.dbFile or null;

  mpdConfText = ''
    music_directory     "${musicDir}"
    playlist_directory  "${playlistDir}"
    ${lib.optionalString (dbFile != null) "db_file \"${dbFile}\""}
    state_file          "${dataDir}/state"
    sticker_file        "${dataDir}/sticker.sql"
    ${lib.optionalString (cfg.mpd.network.listenAddress != "any") "bind_to_address \"${cfg.mpd.network.listenAddress}\""}
    ${lib.optionalString (cfg.mpd.network.port != 6600) "port \"${toString cfg.mpd.network.port}\""}
    ${cfg.mpd.extraConfig}
  '';
in {
  options.dotfiles.services.music = {
    enable = lib.mkEnableOption "MPD + optional clients";

    mpd = {
      enable = lib.mkEnableOption "MPD daemon" // {default = true;};
      package = lib.mkPackageOption pkgs "mpd" {};
      musicDirectory = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Music directory. If null, uses ~/Music.";
      };
      playlistDirectory = lib.mkOption {
        type = lib.types.path;
        default = "${dataDir}/playlists";
      };
      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "${xdgData}/mpd";
      };
      dbFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
      network = {
        startWhenNeeded = lib.mkEnableOption "socket activation (Linux only)" // {default = false;};
        listenAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 6600;
        };
      };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };

    rmpc = {
      enable = lib.mkEnableOption "rmpc TUI client" // {default = true;};
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };

    discordRpc = {
      enable = lib.mkEnableOption "mpd-discord-rpc (ignored if host lacks desktop)";
    };

    mpdris2 = {
      enable = lib.mkEnableOption "mpdris2 MPRIS bridge (ignored if host lacks desktop)";
      multimediaKeys = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      notifications = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      mpd = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Packages: always include mpd, conditionally include clients
    packages = with pkgs;
      [
        cfg.mpd.package
      ]
      ++ lib.optional cfg.rmpc.enable rmpc
      ++ lib.optional (cfg.discordRpc.enable && hasDesktop) mpd-discord-rpc
      ++ lib.optional (cfg.mpdris2.enable && hasDesktop) mpdris2;

    # MPD config file
    xdg.config.files."mpd/mpd.conf" = lib.mkIf cfg.mpd.enable {
      text = mpdConfText;
    };

    # MPD service (always enabled if user asked, regardless of desktop)
    systemd.services.mpd = lib.mkIf cfg.mpd.enable {
      description = "Music Player Daemon";
      after = ["network.target" "sound.target"] ++ lib.optionals cfg.mpd.network.startWhenNeeded ["mpd.socket"];
      wantedBy = lib.mkIf (!cfg.mpd.network.startWhenNeeded) ["default.target"];
      requires = lib.mkIf cfg.mpd.network.startWhenNeeded ["mpd.socket"];

      serviceConfig = {
        Type = "notify";
        ExecStart = ''
          ${cfg.mpd.package}/bin/mpd --no-daemon \
            ${xdgConfig}/mpd/mpd.conf \
            ${lib.escapeShellArgs cfg.mpd.extraArgs}
        '';
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p '${dataDir}' '${playlistDir}'";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # MPD socket (optional)
    systemd.sockets.mpd = lib.mkIf (cfg.mpd.enable && cfg.mpd.network.startWhenNeeded) {
      description = "MPD socket activation";
      wantedBy = ["sockets.target"];
      socketConfig = {
        ListenStream = let
          addr =
            if cfg.mpd.network.listenAddress == "any"
            then toString cfg.mpd.network.port
            else "${cfg.mpd.network.listenAddress}:${toString cfg.mpd.network.port}";
        in [addr "%t/mpd/socket"];
        Backlog = 5;
        KeepAlive = true;
      };
    };

    # rmpc config & desktop entry (always if enabled)
    xdg.config.files."rmpc/config.ron" = lib.mkIf cfg.rmpc.enable {
      text = ''
        (
          max_fps: 60,
          enable_mouse: true,
          ${cfg.rmpc.extraConfig}
        )
      '';
    };
    xdg.data.files."applications/rmpc.desktop" = lib.mkIf cfg.rmpc.enable {
      text = ''
        [Desktop Entry]
        Name=rmpc
        GenericName=MPD Client
        Comment=A modern, configurable terminal MPD client
        Exec=rmpc
        Icon=multimedia-player
        Terminal=true
        Type=Application
        Categories=Audio;AudioVideo;Music;Player;ConsoleOnly;
        Keywords=music;mpd;player;audio;tui;
      '';
    };

    # mpd‑discord‑rpc service (only if user wants AND host has desktop)
    systemd.services.mpd-discord-rpc = lib.mkIf (cfg.discordRpc.enable && hasDesktop) {
      description = "MPD Discord Rich Presence";
      after = ["mpd.service"];
      partOf = ["mpd.service"];
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = "${pkgs.mpd-discord-rpc}/bin/mpd-discord-rpc";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # mpdris2 service (only if user wants AND host has desktop)
    systemd.services.mpdris2 = lib.mkIf (cfg.mpdris2.enable && hasDesktop) {
      description = "MPRIS2 bridge for MPD";
      after = ["mpd.service" (lib.mkif hyprlandOn "quickshell.service")];
      partOf = ["mpd.service"];
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = let
          args =
            lib.optionalString (!cfg.mpdris2.multimediaKeys) "--no-multimedia-keys "
            + lib.optionalString (!cfg.mpdris2.notifications) "--no-notifications ";
        in "${lib.getExe pkgs.mpdris2} ${args}--host ${cfg.mpdris2.mpd.host}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    environment.sessionVariables =
      lib.mkIf cfg.mpd.enable {
        MPD_PORT = toString cfg.mpd.network.port;
      }
      // lib.optionalAttrs (cfg.mpd.network.listenAddress != "any") {
        MPD_HOST = cfg.mpd.network.listenAddress;
      };
  };
}
