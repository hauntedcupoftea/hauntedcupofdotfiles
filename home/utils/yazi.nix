{ pkgs, ... }: {
  home.packages = [ pkgs.yazi ];
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
