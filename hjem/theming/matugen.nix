{pkgs, ...}: {
  files.".config/matugen/config.toml".source =
    (pkgs.formats.toml {}).generate "matugen.toml"
    {
      config = {
        version_check = false;
        fallback_color = "#ffbf9b";
      };

      templates = {
        theme-json = {
          input_path = "~/.config/matugen/templates/theme.json.template";
          output_path = "~/.config/hauntedcupofbar/theme.json";
        };
      };
    };

  files.".config/matugen/templates/theme.json.template".source = ./templates/theme.json.template;
}
