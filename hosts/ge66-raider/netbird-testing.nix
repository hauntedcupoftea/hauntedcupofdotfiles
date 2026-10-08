{pkgs, ...}: {
  services.netbird = {
    enable = true;
    clients.tea-test = {
      port = 51825;
      login = {
        enable = false;
        setupKeyFile = "/flake/netbird-setup-key";
      };
      ui.enable = true;
    };
  };

  systemd.services."netbird-testing".path = [pkgs.shadow pkgs.util-linux];
  networking.firewall.allowedTCPPorts = [3389];
}
