{pkgs, ...}: {
  files.".config/wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust.toml" {
    backend = "wal";
    palette = "saliencedark16";
    check_contrast = true;
    templates = {
      zellij = {
        template = "zellij.kdl";
        target = "~/.config/zellij/themes/wallust.kdl";
      };
      kitty = {
        template = "kitty.conf";
        target = "~/.config/kitty/colors.conf";
      };
      # uncomment once adjust-hue goes through
      # material-you = {
      #   template = "material-you-theme.json";
      #   target = "~/.config/hauntedcupofbar/new-theme.json";
      # };
    };

    hooks = {
      zellij = "touch ~/.config/zellij/themes/wallust.kdl";
      kitty = "kill -10 $(pidof kitty)";
    };
  };

  files.".config/wallust/templates/zellij.kdl".source = ./templates/zellij.kdl;
  files.".config/wallust/templates/kitty.conf".source = ./templates/kitty.conf;
  # files.".config/wallust/templates/material-you.j2".source = ./templates/material-you.j2;
  # files.".config/wallust/templates/material-you-theme.json".source = ./templates/material-you-theme.json;
}
