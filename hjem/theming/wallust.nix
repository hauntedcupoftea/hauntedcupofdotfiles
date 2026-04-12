{pkgs, ...}: {
  files.".config/wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust.toml" {
    backend = "wal";
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
      nvim = {
        template = "nvim-colors.lua";
        target = "~/.config/nvim/wallust-colors.lua";
      };
      gtk3 = {
        template = "gtk-colors.css";
        target = "~/.config/gtk-3.0/colors.css";
      };
      gtk4 = {
        template = "gtk-colors.css";
        target = "~/.config/gtk-4.0/colors.css";
      };
      kvantum = {
        template = "kvantum-colors.kvconfig";
        target = "~/.config/Kvantum/wallust/wallust.kvconfig";
      };
    };

    hooks = {
      zellij = "touch ~/.config/zellij/themes/wallust.kdl";
      kitty = "kill -10 $(pidof kitty)";
      # GTK hot-reload: toggle theme name to force re-read
      gtk3 = ''
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' && \
        gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark'
      '';
      # GTK4 / libadwaita reads color-scheme preference too
      gtk4 = "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
      # kvantum: set active theme (new Qt processes will pick it up)
      kvantum = "kvantummanager --set wallust 2>/dev/null || true";
    };
  };

  files.".config/wallust/templates/zellij.kdl".source = ./templates/zellij.kdl;
  files.".config/wallust/templates/kitty.conf".source = ./templates/kitty.conf;
  files.".config/wallust/templates/nvim-colors.lua".source = ./templates/nvim-colors.lua;
  files.".config/wallust/templates/gtk-colors.css".source = ./templates/gtk-colors.css.template;
  files.".config/wallust/templates/kvantum-colors.kvconfig".source = ./templates/kvantum-colors.kvconfig;
}
