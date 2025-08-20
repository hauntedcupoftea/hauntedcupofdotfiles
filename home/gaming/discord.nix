{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    vesktop
    arrpc
    legcord # testing
  ];

  programs.vesktop = {
    enable = true;
    settings = {
      arrpc = true;
      hardwareAcceleration = true;
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
    "${config.xdg.configHome}/vesktop/settings.json" = {
      source = ../../custom-files/vesktop/settings.json;
    };
  };

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
