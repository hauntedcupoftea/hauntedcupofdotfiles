{pkgs, ...}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland = {
    enableGnomeKeyring = true;
    text = ''
      session optional ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start components=secrets,pkcs11
    '';
  };

  security.pam.services.sddm = {
    enableGnomeKeyring = true;
    text = ''
      session optional ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start components=secrets,pkcs11
    '';
  };

  environment.systemPackages = [
    pkgs.polkit
    pkgs.polkit_gnome
  ];

  # Keep your polkit agent
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
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
