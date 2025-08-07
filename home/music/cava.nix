{ matugenTheme
, ...
}: {
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
        background = "'#${matugenTheme.colors.dark.surface_container_lowest}'";
        gradient = true;
        gradient_color_1 = "'#${matugenTheme.colors.dark.primary}'";
        gradient_color_2 = "'#${matugenTheme.colors.dark.secondary}'";
        gradient_color_3 = "'#${matugenTheme.colors.dark.tertiary}'";
        gradient_color_4 = "'#${matugenTheme.colors.dark.primary_container}'";
        gradient_color_5 = "'#${matugenTheme.colors.dark.secondary_container}'";
        gradient_color_6 = "'#${matugenTheme.colors.dark.tertiary_container}'";
        gradient_color_7 = "'#${matugenTheme.colors.dark.on_secondary_container}'";
        gradient_color_8 = "'#${matugenTheme.colors.dark.on_primary_container}'";
      };

      smoothing = {
        monstercat = true;
        waves = true;
        noise_reduction = 85;
      };
    };
  };
}
