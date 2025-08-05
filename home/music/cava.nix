{ matugenTheme, ... }: {
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
        orientation = "bottom";
        channels = "stereo";
      };

      color = {
        background = "${matugenTheme.colors.dark.surface-container-lowest}";
        gradient = true;
        gradientColors = [
          "${matugenTheme.colors.dark.primary}"
          "${matugenTheme.colors.dark.secondary}"
          "${matugenTheme.colors.dark.tertiary}"
          "${matugenTheme.colors.dark.primary-container}"
          "${matugenTheme.colors.dark.secondary-container}"
          "${matugenTheme.colors.dark.tertiary-container}"
          "${matugenTheme.colors.dark.on-primary-container}"
          "${matugenTheme.colors.dark.on-secondary-container}"
        ];
      };

      smoothing = {
        monstercat = true;
        waves = true;
        noise_reduction = 85;
      };
    };
  };
}
