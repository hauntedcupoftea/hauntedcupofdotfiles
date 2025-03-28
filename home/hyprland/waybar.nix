{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # Waybar settings
    settings = {
      mainBar = {
        "modules-left" = [
          "custom/weather"
          "clock#date"
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
          "exec" = "curl -s 'https://wttr.in/?format=1'";
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

    # Waybar style (Catppuccin Mocha)
    style = ''
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      * {
        font-family: "FiraCode Nerd Font";
        font-size: 12pt;
        font-weight: bold;
        border-radius: 0px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #tray {
        padding-right: 15px;
      }
    '';
  };
}
