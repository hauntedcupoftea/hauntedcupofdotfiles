{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ge66-nixos" = {
        hostname = "203.212.222.186";
        port = 59994;
        user = "tea";
        identityFile = "~/.ssh/ssh-access";
      };

      "ge66-nixos-lan" = {
        hostname = "192.168.50.18";
        port = 59994;
        user = "tea";
        identityFile = "~/.ssh/ssh-access";
      };

      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
