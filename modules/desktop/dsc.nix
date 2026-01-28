{pkgs, ...}: {
  services.pcscd = {
    enable = true;
    plugins = [
      pkgs.opensc
      pkgs.ccid
    ];
  };

  environment.systemPackages = with pkgs; [
    pcscliteWithPolkit
    pcsc-tools
    opensc
  ];

  hardware.gpgSmartcards.enable = true;
}
