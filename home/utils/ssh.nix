{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ge66-nixos-ipv6" = {
        hostname = "2402:e280:3dc7:5fa:ddbe:da66:4eb2:6e8a";
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
