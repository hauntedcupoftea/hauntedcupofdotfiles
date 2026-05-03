{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.cava;
in {
  options.dotfiles.shell.cava.enable =
    lib.mkEnableOption "cava audio visualizer";

  config = lib.mkIf cfg.enable {
    files.".config/cava/config".text = ''
      [general]
      framerate = 60
      autosens = 1
      bars = 0
      bar_width = 1
      bar_spacing = 1
      center_align = 1

      [input]
      method = pipewire
      source = auto

      [output]
      method = noncurses
      waveform = 1
      orientation = bottom
      channels = stereo

      [smoothing]
      monstercat = 1
      waves = 1
      noise_reduction = 85
    '';
  };
}
