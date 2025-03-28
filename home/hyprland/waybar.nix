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
        height = 36;
        spacing = 6;

        "modules-left" = [
          "clock#date"
          "custom/weather"
          "hyprland/workspaces"
          "custom/media"
        ];
        "modules-center" = [
          "hyprland/window"
        ];
        "modules-right" = [
          "idle_inhibitor"
          # "custom/vpn"
          "network"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];

        # Hyprland workspace module
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "all-outputs" = true;
          "on-click" = "hyprctl dispatch workspace {name}";
          "format-icons" = {
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
          };
        };

        # Hyprland window module
        "hyprland/window" = {
          "format" = "{title}";
          "empty-format" = "No active window";
          "tooltip" = false;
        };

        # Idle inhibitor module
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };

        # Tray module
        "tray" = {
          "spacing" = 10;
        };

        # Clock module
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };

        # Date clock module
        "clock#date" = {
          "format" = "{:%d.%m.%Y}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        # Backlight module
        "backlight" = {
          "format" = "{icon} {percent}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        # Battery module
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
          "on-click" = "hyprctl dispatch exec quicksettings";
        };

        # Pulseaudio module
        "pulseaudio" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-bluetooth" = " {icon} {volume}% {format_source}";
          "format-bluetooth-muted" = "  {icon} {format_source}";
          "format-muted" = "  {format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = "";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };

        # Custom weather module
        "custom/weather" = {
          "format" = "{}";
          "interval" = 3600;
          "exec" = "curl -s 'https://wttr.in/?d&format=%20%m%20%C%20%t(%f)%20%w'";
          "exec-if" = "ping wttr.in -c1";
        };

        # Custom VPN module
        # "custom/vpn" = {
        #   "tooltip" = false;
        #   "format" = "VPN {}";
        #   "exec" = "mullvad status | grep -q 'Connected' && echo '' || echo ''";
        #   "interval" = 5;
        #   "on-click" = "mullvad connect";
        #   "on-click-right" = "mullvad disconnect";
        # };

        # Network module
        "network" = {
          "format-wifi" = " {essid} ({signalStrength}%)";
          "format-ethernet" = "⬇{bandwidthDownBytes} ⬆{bandwidthUpBytes}";
          "interval" = 3;
          "format-linked" = "{ifname} (No IP) ";
          "format" = "";
          "format-disconnected" = "";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "on-click" = "wl-copy $(ip address show up scope global | grep inet | head -n1 | cut -d/ -f 1 | tr -d [:space:] | cut -c5-)";
          "tooltip-format" = " {bandwidthUpBits}  {bandwidthDownBits}\n{ifname}\n{ipaddr}/{cidr}\n";
          "tooltip-format-wifi" = " {essid} {frequency}MHz\nStrength: {signaldBm}dBm ({signalStrength}%)\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
          "min-length" = 17;
          "max-length" = 17;
        };
      };
    };
  };
}
