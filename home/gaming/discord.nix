{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    arrpc
  ];

  programs.vesktop = {
    enable = true;
  };

  home.file = {
    ".config/vesktop/themes" = {
      source = ../../custom-files/vesktop/themes;
      recursive = true;
    };
  };

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
