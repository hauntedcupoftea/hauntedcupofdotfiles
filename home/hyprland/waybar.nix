{ ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 6;
        marin-bottom = 0;

        "modules-left" = [
          "clock"
          "custom/weather"
          # "custom/media"
          "hyprland/window"
        ];
        "modules-center" = [
          # "hyprland/window"
          "hyprland/workspaces"
        ];
        "modules-right" = [
          "idle_inhibitor"
          # "custom/vpn"
          "network"
          "bluetooth"
          "pulseaudio"
          # "battery"
          "tray"
          "group/hardware"
          "custom/power"
        ];

        "temperature" = {
          "hwmon-path" = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input"; # YMMV
        };

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
          "format" = "󰣆 {title}";
          "max-length" = 30;
          "separate-outputs" = false;
          "rewrite" = {
            "^.*( — Firefox| - Mozilla Firefox|Firefox| — Zen Browser| — Zen Twilight|Zen Twilight)$" = " Zen Browser";
            "^.*( — VSCode| - VSCodium)$" = " Code";
            ".*(Zellij|zellij|fish).*" = " Kitty";
            ".*(Discord|discord).*" = " Discord (Vesktop)";
            "^.*(Steam|steam)$" = " Steam";
            ".*(hx|Hx|hX|HX).*" = "󰚄 Helix";
            "^.*~$" = " Backup";
            "(.*) " = " Empty";
          };
          "window-rewrite-default" = " {title}";
        };

        # Bluetooth
        "bluetooth" = {
          "format" = "󰂯";
          "format-disabled" = "󰂲";
          "format-off" = "󰂲";
          "interval" = 30;
          "on-click" = "overskride";
          "on-click-right" = "killall -SIGUSR1 overskride";
          "format-no-controller" = "";
        };

        "custom/power" = {
          "format" = "";
          "on-click" = "wleave";
          "tooltip-format" = "Power Menu";
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

        "group/hardware" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" = [
            "battery"
            "cpu"
            "memory"
            "temperature"
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
              " "
              " "
              " "
            ];
          };
          "on-click" = "pavucontrol";
        };

        # Custom weather module
        "custom/weather" = {
          "format" = "{}";
          "interval" = 3600;
          "exec" = "curl -s 'https://wttr.in/?d&format=%20%m%20%C%20%t%20(%f)%20%w'";
          "exec-if" = "ping wttr.in -c1";
        };

        # Network module
        "network" = {
          "format-wifi" = "  ({signalStrength}%) {essid}";
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
