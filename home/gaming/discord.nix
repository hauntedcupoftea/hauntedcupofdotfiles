{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    vesktop
    arrpc
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
    "${config.xdg.configHome}/vesktop/settings/settings.json" = {
      source = ../../custom-files/vesktop/settings.json;
    };
  };

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
