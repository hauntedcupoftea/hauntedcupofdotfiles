{ pkgs, ... }: {
  # catppuccin.wlogout = {
  #   enable = true;
  #   iconStyle = "wleave";
  #   extraStyle = ''
  #     window {
  #       background-color: rgba(15, 15, 16, 0.6);
  #     }

  #     button {
  #       border-radius: 8px;
  #       margin: 8px;
  #     }
  #   '';
  # };

  programs.wlogout = {
    enable = true;
    package = pkgs.wleave; # replace with wleave as a test
    style =
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
        	background-image: url("${../../custom-files/wleave/icons/lock.png}");
        }

        #lock:focus {
        	background-image: url("${../../custom-files/wleave/icons/lock-hover.png}");
        }

        #logout {
        	background-image: url("${../../custom-files/wleave/icons/logout.png}");
        }

        #logout:focus {
        	background-image: url("${../../custom-files/wleave/icons/logout-hover.png}");
        }

        #suspend {
        	background-image: url("${../../custom-files/wleave/icons/sleep.png}");
        }

        #suspend:focus {
        	background-image: url("${../../custom-files/wleave/icons/sleep-hover.png}");
        }

        #shutdown {
        	background-image: url("${../../custom-files/wleave/icons/power.png}");
        }

        #shutdown:focus {
        	background-image: url("${../../custom-files/wleave/icons/power-hover.png}");
        }

        #reboot {
        	background-image: url("${../../custom-files/wleave/icons/restart.png}");
        }

        #reboot:focus {
        	background-image: url("${../../custom-files/wleave/icons/restart-hover.png}");
        }
    '';
    layout = [
      {
        "buttons" = [
          {
            "label" = "lock";
            "action" = "hyprlock";
            "text" = "Lock";
            "keybind" = "l";
          }
          {
            "label" = "reboot";
            "action" = "systemctl reboot";
            "text" = "Reboot";
            "keybind" = "r";
          }
          {
            "label" = "shutdown";
            "action" = "systemctl poweroff";
            "text" = "Shutdown";
            "keybind" = "s";
          }
          {
            "label" = "logout";
            "action" = "uwsm stop";
            "text" = "Logout";
            "keybind" = "e";
          }
          {
            "label" = "suspend";
            "action" = "systemctl suspend";
            "text" = "Suspend";
            "keybind" = "u";
          }
          {
            "label" = "hibernate";
            "action" = "systemctl hibernate";
            "text" = "Hibernate";
            "keybind" = "h";
          }
        ];
      }
    ];
  };
}
