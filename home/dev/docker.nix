{ pkgs, ... }: {
  programs.lazydocker.enable = true;
  # "dns": ["1.1.1.1", "8.8.8.8"],
  home = {
    packages = [
      pkgs.lazydocker
    ];
    file = {
      ".config/docker/daemon.json" = {
        text = ''
          {
            "ipv6": false,
            "experimental": false
          }
        '';
      };
    };
  };
}
