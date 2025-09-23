{pkgs, ...}: {
  home.packages = with pkgs; [
    rmpc
  ];

  services = {
    mpd = {
      enable = true;
    };
    mpd-discord-rpc = {
      enable = true;
    };
    mpd-mpris = {
      enable = true;
    };
  };
}
