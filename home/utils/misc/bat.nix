{ pkgs, ... }: {

  home.packages = [ pkgs.bat ];

  programs.bat = {
    enable = true;
    package = pkgs.bat;
  };
}
