{...}: {
  programs.ssh.extraConfig = ''
    Host ge66-nixos-ipv6
      HostName 2402:e280:3dc7:5fa:ddbe:da66:4eb2:6e8a
      Port 59994
      User tea
      IdentityFile ~/.ssh/ssh-access

    Host ge66-nixos-lan
      HostName 192.168.50.18
      Port 59994
      User tea
      IdentityFile ~/.ssh/ssh-access

    Host github
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519
  '';
}
