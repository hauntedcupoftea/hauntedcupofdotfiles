{
  lib,
  pkgs,
  config,
  ...
}: let
  when = cond: attrs:
    if cond
    then attrs
    else {};

  z = config.dotfiles.shell.zellij.enable;
  k = config.dotfiles.desktop.kitty.enable;
  g = config.dotfiles.desktop.ghostty.enable;
  r = config.dotfiles.desktop.rio.enable;
  w = config.dotfiles.desktop.wezterm.enable;

  wallustTemplates = lib.mergeAttrsList [
    (when z {
      zellij = {
        template = "zellij.kdl";
        target = "~/.config/zellij/themes/wallust.kdl";
      };
    })
    (when k {
      kitty = {
        template = "kitty.conf";
        target = "~/.config/kitty/colors.conf";
      };
    })
    (when g {
      ghostty = {
        template = "wallust.ghostty";
        target = "~/.config/ghostty/themes/wallust";
      };
    })
    (when r {
      rio = {
        template = "rio.toml";
        target = "~/.config/rio/themes/wallust.toml";
      };
    })
    (when w {
      wezterm = {
        template = "wezterm.toml";
        target = "~/.config/wezterm/colors/wallust.toml";
      };
    })
    {
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
      theme-json = {
        template = "wallust-theme.json";
        target = "~/.config/wallust/theme.json";
      };
    }
  ];

  wallustHooks = lib.mergeAttrsList [
    (when z {zellij = "touch ~/.config/zellij/themes/wallust.kdl";})
    (when k {kitty = "kill -SIGUSR1 $(pidof kitty)";})
    (when g {ghostty = "kill -SIGUSR2 $(pidof ghostty)";})
    {
      gtk3 = ''
        dconf write /org/gnome/desktop/interface/gtk-theme \"'Adwaita'\" && \
        sleep 0.3 && \
        dconf write /org/gnome/desktop/interface/gtk-theme \"'Colloid-Dark'\"
      '';
      gtk4 = ''
        dconf write /org/gnome/desktop/interface/color-scheme "'default'" && \
        sleep 0.3 && \
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
    }
  ];

  wallustTemplateFiles = lib.mergeAttrsList [
    (when z {".config/wallust/templates/zellij.kdl".source = ./templates/zellij.kdl;})
    (when k {".config/wallust/templates/kitty.conf".source = ./templates/kitty.conf;})
    (when g {".config/wallust/templates/wallust.ghostty".source = ./templates/wallust.ghostty;})
    (when r {".config/wallust/templates/rio.toml".source = ./templates/rio.toml;})
    (when w {".config/wallust/templates/wezterm.toml".source = ./templates/wezterm.toml;})
    {
      ".config/wallust/templates/nvim-colors.lua".source = ./templates/nvim-colors.lua;
      ".config/wallust/templates/gtk-colors.css".source = ./templates/gtk-colors.css.template;
      ".config/wallust/templates/kvantum-colors.kvconfig".source = ./templates/kvantum-colors.kvconfig;
      ".config/wallust/templates/wallust-theme.json".source = ./templates/wallust-theme.json;
    }
  ];
in {
  files =
    wallustTemplateFiles
    // {
      ".config/wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust.toml" {
        backend = "wal";
        check_contrast = true;
        templates = wallustTemplates;
        hooks = wallustHooks;
      };
    };
}
