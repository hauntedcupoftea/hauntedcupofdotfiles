{ pkgs, ... }: {
  programs.lazydocker.enable = true;
  home = {
    packages = [
      pkgs.lazydocker
    ];
    file = {
      ".config/docker/daemon.json" = {
        text = ''
          {
            "dns": ["1.1.1.1", "8.8.8.8"],
            "ipv6": false,
            "experimental": false
          }
        '';
      };
    };
  };
}
