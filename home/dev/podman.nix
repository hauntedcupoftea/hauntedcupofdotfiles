{ pkgs, ... }: {
  programs.lazydocker.enable = true;

  home = {
    packages = with pkgs; [
      podman-tui
      dive
      docker-compose
    ];
  };
}
