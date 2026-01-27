{pkgs, ...}: {
  services.pcscd = {
    enable = true;
    plugins = [
      pkgs.ccid
    ];
  };

  hardware.gpgSmartcards.enable = true;
}
