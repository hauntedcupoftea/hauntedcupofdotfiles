{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12pt;
        font-weight: bold;
        border-radius: 0px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.5);
        border-bottom: 2px solid rgba(205, 214, 244, 0.2);
        color: #cdd6f4;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspace,
      #mode,
      #window,
      #idle_inhibitor,
      #clock,
      #pulseaudio,
      #network,
      #temperature,
      #backlight,
      #battery,
      #tray {
        background-color: rgba(30, 30, 46, 0.5);
        padding: 0 10px;
        margin: 4px 0px;
        border: 2px solid rgba(205, 214, 244, 0);
      }

      #workspaces button {
        background-color: rgba(30, 30, 46, 0.5);
        color: #cdd6f4;
        border-radius: 8px;
        margin: 4px 2px;
        padding: 0px 10px;
        font-weight: bold;
        border: 0px solid #cdd6f4;
      }

      #workspaces button.active {
        background-color: #cba6f7;
        color: #1e1e2e;
        border-radius: 8px;
        margin: 4px 2px;
        padding: 0px 10px;
        font-weight: bold;
        border: 0px solid #cdd6f4;
      }

      #workspaces button:hover {
        background-color: #f5c2e7;
        color: #1e1e2e;
        border-radius: 8px;
      }

      #clock {
        color: #fab387;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #f9e2af;
      }

      #battery.warning:not(.charging) {
        color: #f38ba8;
      }

      #network {
        color: #89b4fa;
      }

      #pulseaudio {
        color: #89dceb;
      }

      #temperature {
        color: #f5c2e7;
      }

      #temperature.critical {
        color: #f38ba8;
      }

      #tray {
        padding-right: 15px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "temperature"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          all-outputs = true;
          on-click = "activate";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };

        "clock" = {
          format = "{:%H:%M}  ";
          format-alt = "{:%Y-%m-%d %H:%M:%S}  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        "battery" = {
          states = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Ethernet ";
          format-linked = "Ethernet (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "Muted ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "temperature" = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C ";
          format = "{temperatureC}°C ";
        };

        "tray" = {
          spacing = 10;
        };
      };
    };
  };

  # Install necessary packages
  home.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
    pavucontrol
  ];
}
