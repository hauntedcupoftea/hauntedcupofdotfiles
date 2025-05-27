{ ... }: {
  # virtualisation.containers.enable = true;
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        ipv6 = false;
        experimental = false;
      };
    };
    enableNvidia = true;
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };
}
