{pkgs, ...}: {
  imports = [
    ../../services/embridge.nix
  ];

  services.embridge.enable = false;

  services.pcscd = {
    enable = true;
    plugins = [pkgs.ccid];
  };

  environment.systemPackages = with pkgs; [
    embridge
    pcscliteWithPolkit
    pcsc-tools
    opensc
  ];
}
