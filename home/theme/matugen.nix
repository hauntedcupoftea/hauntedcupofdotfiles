{ matugenTheme, ... }: {
  home.file.".config/matugen/theme.json" = {
    source = "${matugenTheme}/theme.json";
  };
}
