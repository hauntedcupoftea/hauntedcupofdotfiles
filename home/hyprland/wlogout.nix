{ pkgs, ... }: {
  home.packages = with pkgs; [ wayland-logout ];

  catppuccin.wlogout = {
    enable = true;
    iconStyle = "wleave";
    extraStyle = ''
      button {
        border-radius: 8px;
        margin: 8px;
      }
    '';
  };

  programs.wlogout = {
    enable = true;
    package = pkgs.wleave; # replace with wleave as a test
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
            "action" = "wayland-logout";
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
