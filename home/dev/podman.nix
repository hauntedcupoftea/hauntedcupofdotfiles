{pkgs, ...}: {
  programs.lazydocker.enable = true;

  services.podman = {
    enable = true;
  };

  home = {
    packages = with pkgs; [
      podman-tui
      dive
      podman-compose
    ];
  };
}
