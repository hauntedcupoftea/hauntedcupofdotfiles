{ pkgs, ... }: {
  home.packages = [
    pkgs.seahorse
  ];
  services.gnome-keyring = {
    enable = true;
    unlockOnLogin = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };
}
