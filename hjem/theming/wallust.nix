{pkgs, ...}: {
  files.".config/wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust.toml" {
    backend = "resized";
    palette = "dark16";
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
    };

    hooks = {
      zellij = "touch ~/.config/zellij/themes/wallust.kdl";
      kitty = "kill -10 $(pidof kitty)";
    };
  };

  files.".config/wallust/templates/zellij.kdl".source = ./templates/zellij.kdl;
  files.".config/wallust/templates/kitty.conf".source = ./templates/kitty.conf;
}
