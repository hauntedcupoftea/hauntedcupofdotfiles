{
  config,
  nixosConfig,
  ...
}: {
  assertions = [
    {
      assertion = !config.dotfiles.services.music.mpdscribble.enable || config.dotfiles.services.music.mpd.enable;
      message = "mpdscribble cannot be enabled without mpd (dotfiles.services.music.mpd.enable)";
    }
  ];
}
