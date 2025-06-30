{ pkgs, config, ... }: {
  # disable the catppuccin theming defaults
  home.packages = [ pkgs.wleave ];

  home.file = {
    "${config.xdg.configHome}/wlogout/icons" = {
      source = ../../custom-files/wleave/icons;
      recursive = true;
    };
    "${config.xdg.configHome}/wleave/style.css".text =
      # css
      ''       
        window {
         	font-family: monospace;
         	font-size: 20pt;
         	color: #c0caf5;
         	/* text */
         	background-color: rgba(30, 30, 46, 0.85);
        }

        button {
         	border-radius: 8px;
         	background-repeat: no-repeat;
         	background-position: center;
         	background-size: 50%;
         	border-style: solid;
          border-width: 1px;
          border-color: #89b4fa;
         	background-color: #181825;
         	margin: 8px;
         	transition:
         		box-shadow 0.1s ease-in-out,
         		background-color 0.1s ease-in-out;
        }

        button:focus, button:active, button:hover {
        	background-color: rgb(48, 50, 66);
          outline-style: none;
        }

        #lock {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/lock.png");
        }

        #lock:focus {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/lock-hover.png");
        }

        #logout {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/logout.png");
        }

        #logout:focus {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/logout-hover.png");
        }

        #suspend {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/sleep.png");
        }

        #suspend:focus {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/sleep-hover.png");
        }

        #shutdown {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/power.png");
        }

        #shutdown:focus {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/power-hover.png");
        }

        #reboot {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/restart.png");
        }

        #reboot:focus {
        	background-image: url("${config.xdg.configHome}/wlogout/icons/restart-hover.png");
        }
    '';
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
