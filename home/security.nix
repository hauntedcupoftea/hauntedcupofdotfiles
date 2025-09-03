{pkgs, ...}: {
  home.packages = [
    pkgs.seahorse
  ];

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets"];
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
