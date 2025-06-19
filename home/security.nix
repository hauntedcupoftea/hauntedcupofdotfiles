{ pkgs, ... }: {
  home.packages = [
    pkgs.seahorse
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
