{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    vesktop
    arrpc
  ];

  programs.vesktop = {
    enable = true;
    settings = {
      customTitleBar = false;
      disableMinSize = true;
      arRPC = true;
      hardwareVideoAcceleration = true;
      hardwareAcceleration = true;
      splashThemeing = true;
    };
  };

  home.file = {
    "${config.xdg.configHome}/vesktop/themes" = {
      source = ../../custom-files/vesktop/themes;
      recursive = true;
    };
    "${config.xdg.configHome}/vesktop/settings" = {
      source = ../../custom-files/vesktop/settings;
      recursive = true;
    };
  };
}
