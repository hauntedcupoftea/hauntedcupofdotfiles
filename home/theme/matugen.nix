{ matugenTheme, ... }: {
  home.file.".config/matugen/theme.json" = {
    source = "${matugenTheme.files}/theme.json";
  };
}
