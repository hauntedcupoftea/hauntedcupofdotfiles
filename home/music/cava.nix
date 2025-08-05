{
  # matugenTheme,
  ...
}: {
  programs.cava = {
    enable = true;
    # settings = {
    #   general = {
    #     framerate = 60;
    #     autosens = true;
    #     bars = 0;
    #     bar_width = 1;
    #     bar_spacing = 1;
    #     center_align = true;
    #   };

    #   input = {
    #     method = "pipewire";
    #     source = "auto";
    #   };

    #   output = {
    #     method = "noncurses";
    #     orientation = "bottom";
    #     channels = "stereo";
    #   };

    #   color = {
    #     background = "${matugenTheme.colors.dark.surface_container_lowest}";
    #     gradient = true;
    #     gradientColors = [
    #       "${matugenTheme.colors.dark.primary}"
    #       "${matugenTheme.colors.dark.secondary}"
    #       "${matugenTheme.colors.dark.tertiary}"
    #       "${matugenTheme.colors.dark.primary_container}"
    #       "${matugenTheme.colors.dark.secondary_container}"
    #       "${matugenTheme.colors.dark.tertiary_container}"
    #       "${matugenTheme.colors.dark.on_primary_container}"
    #       "${matugenTheme.colors.dark.on_secondary_container}"
    #     ];
    #   };

    #   smoothing = {
    #     monstercat = true;
    #     waves = true;
    #     noise_reduction = 85;
    #   };
    # };
  };
}
