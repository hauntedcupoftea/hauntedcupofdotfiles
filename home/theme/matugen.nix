{ config, ... }: {
  home.file.".config/matugen/theme.json" = {
    source = "${config.programs.matugen.theme.files}/theme.json";
  };
}
