{
  lib,
  pkgs,
  ...
}: let
  openlinkhub-with-static = pkgs.openlinkhub.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        mkdir -p $out/share/OpenLinkHub
        cp -r database $out/share/OpenLinkHub
        cp -r static $out/share/OpenLinkHub
        cp -r web $out/share/OpenLinkHub

        mkdir -p $out/lib/udev/rules.d/
        cp *.rules $out/lib/udev/rules.d/
      '';
  });
in {
  users.users.openlinkhub = {
    isSystemUser = true;
    group = "openlinkhub";
  };
  users.groups.openlinkhub = {};

  systemd.services.OpenLinkHub = {
    description = "Open source interface for Corsair iCUE LINK hubs, fans, and AIOs";
    after = ["sleep.target"];
    wantedBy = ["multi-user.target"];
    script = ''
      for dir in database static web; do
        if ! [[ -d "$dir" ]]; then
          echo "Copying static $dir to working directory..."
          cp -r ${openlinkhub-with-static}/share/OpenLinkHub/$dir .
          chmod -R u+w $dir
        fi
      done
      exec ${lib.getExe openlinkhub-with-static}
    '';

    serviceConfig = {
      User = "openlinkhub";
      Group = "openlinkhub";
      RestartSec = 5;
      StateDirectory = "OpenLinkHub";
      WorkingDirectory = "/var/lib/OpenLinkHub";
      ReadWritePaths = ["/var/lib/OpenLinkHub"];
      Restart = "on-failure";
    };
    path = [pkgs.pciutils];
  };

  environment.systemPackages = [openlinkhub-with-static];
  services.udev.packages = [openlinkhub-with-static];
}
