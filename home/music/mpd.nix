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
    };
    mpd-discord-rpc = {
      enable = true;
    };
    mpd-mpris = {
      enable = true;
    };
  };

  xdg.desktopEntries.rmpc = {
    name = "rmpc";
    genericName = "MPD Client";
    comment = "A modern, configurable terminal MPD client";
    exec = "rmpc";
    icon = "multimedia-audio-player";
    terminal = true;
    type = "Application";
    categories = ["Audio" "AudioVideo" "Music" "Player" "ConsoleOnly"];
    settings = {
      Keywords = "music;mpd;player;audio;tui;";
    };
  };
}
