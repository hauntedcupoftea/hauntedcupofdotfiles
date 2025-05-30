{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
  ];

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
