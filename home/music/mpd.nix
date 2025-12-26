{...}: {
  programs.rmpc = {
    enable = true;
    config = ''
      (
        max_fps: 60,
        enable_mouse: true,
      )
    '';
  };

  services = {
    mpd = {
      enable = true;
      network = {
        listenAddress = "::";
      };
    };
    mpd-discord-rpc = {
      enable = true;
    };
    mpdris2 = {
      enable = true;
      multimediaKeys = true;
      notifications = true;
      mpd = {
        host = "127.0.0.1";
      };
    };
  };

  xdg.desktopEntries.rmpc = {
    name = "rmpc";
    genericName = "MPD Client";
    comment = "A modern, configurable terminal MPD client";
    exec = "rmpc";
    icon = "multimedia-player";
    terminal = true;
    type = "Application";
    categories = ["Audio" "AudioVideo" "Music" "Player" "ConsoleOnly"];
    settings = {
      Keywords = "music;mpd;player;audio;tui;";
    };
  };
}
