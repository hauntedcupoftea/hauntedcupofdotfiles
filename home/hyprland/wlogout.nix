{pkgs, ...}: {
  programs.wlogout = {
    enable = true;
    package = pkgs.wlogout;
    # style = ''
    #   window {
    #     font-family: JetBrainMono;
    #     font-size: 14px;
    #     color: alpha(@color15, 0.7);
    #     background-color: alpha(@color0, 0.9);
    #   }

    #   button {
    #     background-repeat: no-repeat;
    #     background-position: center;
    #     background-size: 20%;
    #     border: 1px solid alpha(@color11, 0.63);
    #     border-radius: 6px;
    #     margin: 5px;
    #   }

    #   button:focus {
    #     border: 0px;
    #   }

    #   button:hover {
    #     background-color: @color11;
    #     color: #1e1e2e;
    #     background-size: 30%;
    #     transition: all 0.3s cubic-bezier(0.55, 0, 0.28, 1.682),
    #       box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
    #   }

    #   button span {
    #     font-size: 0.2em;
    #   }
    # '';
    layout = [
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
        "action" = "loginctl kill-session $XDG_SESSION_ID";
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
  };
}
