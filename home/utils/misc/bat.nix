{ pkgs, ... }: {

  home.packages = [ pkgs.bat ];

  catppuccin.bat.enable = true;

  programs.bat = {
    enable = true;
    package = pkgs.bat;
  };
}
