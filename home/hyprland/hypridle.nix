{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [pkgs.hypridle];
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "${lib.getExe inputs.quickshell.packages.${pkgs.system}.default} -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell/ ipc call lockscreen lock";

        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150; # 2.5 minutes.
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 150; # 2.5 minutes.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 300; # 5 minutes
          on-timeout = "${lib.getExe inputs.quickshell.packages.${pkgs.system}.default} -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell/ ipc call lockscreen lock";
        }

        {
          timeout = 360; # 6 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
        # {
        #   timeout = 1800; # 30min
        #   on-timeout = "systemctl suspend"; # suspend pc
        # }
      ];
    };
  };
}
