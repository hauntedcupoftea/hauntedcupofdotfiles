{ pkgs, config, ... }: {
  home.packages = [ pkgs.wleave ];

  home.file = {
    "${config.xdg.configHome}/wleave/icons" = {
      source = ../../custom-files/wleave/icons;
      recursive = true;
    };
    "${config.xdg.configHome}/wleave/layout.json".text =
      # json
      ''
        {
          "buttons": [
            {
              "label": "lock",
              "action": "hyprlock",
              "text": "Lock",
              "keybind": "l"
            },
            {
              "label": "reboot",
              "action": "systemctl reboot",
              "text": "Reboot",
              "keybind": "r"
            },
            {
              "label": "shutdown",
              "action": "systemctl poweroff",
              "text": "Shutdown",
              "keybind": "s"
            },
            {
              "label": "logout",
              "action": "uwsm stop",
              "text": "Logout",
              "keybind": "e"
            },
            {
              "label": "suspend",
              "action": "systemctl suspend",
              "text": "Suspend",
              "keybind": "u"
            },
            {
              "label": "hibernate",
              "action": "systemctl hibernate",
              "text": "Hibernate",
              "keybind": "h"
            }
          ]
        }
      '';
  };
}
