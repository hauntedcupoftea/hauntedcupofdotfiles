{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    vesktop
    arrpc
  ];

  programs.vesktop = {
    enable = true;
  };

  home.file = {
    "${config.xdg.configHome}/vesktop/themes" = {
      source = ../../custom-files/vesktop/themes;
      recursive = true;
    };
  };

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
