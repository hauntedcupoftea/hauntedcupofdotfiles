{pkgs, ...}: {
  imports = [
    # ./ags.nix
    ./git.nix
    ./firefox.nix
    ./nvf.nix
    ./helix.nix
    ./py.nix
    ./podman.nix
    ./quickshell.nix
    # ./rust.nix # BETTER IN DEVSHELLS
    ./ts.nix
    ./typst.nix
  ];

  home.packages = with pkgs; [
    bruno # api testing tool that works on plaintext
    zrok # self hosted ngrok
    zathura # PDF viewer
    gh # GitHub-cli
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/shared/Code/";
    SECURITY_PROJECT = "/shared/Code/K2O2/security-management";
  };
}
