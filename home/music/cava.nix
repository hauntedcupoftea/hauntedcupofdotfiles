{...}: {
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        autosens = true;
        bars = 0;
        bar_width = 1;
        bar_spacing = 1;
        center_align = true;
      };

      input = {
        method = "pipewire";
        source = "auto";
      };

      output = {
        method = "noncurses";
        waveform = true;
        orientation = "bottom";
        channels = "stereo";
      };

      smoothing = {
        monstercat = true;
        waves = true;
        noise_reduction = 85;
      };
    };
  };
}
