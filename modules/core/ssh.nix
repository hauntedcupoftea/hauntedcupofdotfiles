{...}: {
  services.fail2ban.enable = true;

  services.openssh = {
    enable = true;
    ports = [59994];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["tea"];
    };
  };

  users.users.tea.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKR/l+Mr/elboO6CRwMsWLf6I/LPwaYkH1M4s054FYK2 tea@android-nixos"];
}
