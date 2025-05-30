{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    arrpc
  ];

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
