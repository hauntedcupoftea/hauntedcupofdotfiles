{ ... }: {
  imports = [
    ./ags.nix
    ./nvf.nix
    ./helix.nix
    ./py.nix
    ./rust.nix
    ./ts.nix
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/mnt/media/Code/";
    SECURITY_PROJECT = "/mnt/media/Code/K2O2/security-management";
  };
}
