{matugenTheme, ...}: {
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

      color = {
        background = "'#${matugenTheme.colors.surface_container_lowest.default}'";
        gradient = true;
        gradient_color_1 = "'#${matugenTheme.colors.primary.default}'";
        gradient_color_2 = "'#${matugenTheme.colors.secondary.default}'";
        gradient_color_3 = "'#${matugenTheme.colors.tertiary.default}'";
        gradient_color_4 = "'#${matugenTheme.colors.primary_container.default}'";
        gradient_color_5 = "'#${matugenTheme.colors.secondary_container.default}'";
        gradient_color_6 = "'#${matugenTheme.colors.tertiary_container.default}'";
        gradient_color_7 = "'#${matugenTheme.colors.on_secondary_container.default}'";
        gradient_color_8 = "'#${matugenTheme.colors.on_primary_container.default}'";
      };

      smoothing = {
        monstercat = true;
        waves = true;
        noise_reduction = 85;
      };
    };
  };
}
