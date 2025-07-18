{ pkgs, ... }: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };
  security.polkit.enable = true;

  # enable gnome-keyring because it just works(tm)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.systemPackages = [
    pkgs.polkit
    pkgs.polkit_gnome
  ];

  # gnome polkit auto-start from nix wiki
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
