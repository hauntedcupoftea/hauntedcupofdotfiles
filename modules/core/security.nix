{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.gaze.nixosModules.default];
  services.gaze = {
    enable = true;
    gui.enable = true;
  };

  security.pam.services.sudo.gaze = {
    enable = true;
    control = "sufficient";
    simultaneous = true;
  };

  security.pam.services.polkit-1.gaze = {
    enable = true;
    control = "sufficient";
    simultaneous = true;
  };

  security.rtkit.enable = true;
  security.sudo.enable = true;

  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.ssh.startAgent = true;

  environment.systemPackages = [
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.keepassxc
  ];

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
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
