{ pkgs, ... }: {
  programs.lazydocker.enable = true;
  home.packages = [
    pkgs.lazydocker
  ];
}
