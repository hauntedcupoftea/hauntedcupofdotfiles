{ pkgs, ... }: {
  imports = [
    # ./ags.nix
    ./git.nix
    ./nvf.nix
    ./helix.nix
    ./py.nix
    ./podman.nix
    ./quickshell.nix
    ./rust.nix
    ./ts.nix
    ./typst.nix
  ];

  home.packages = with pkgs; [
    bruno # api testing tool that works on plaintext
    geckodriver # selenium-like browser automation for firefox
    zrok # self hosted ngrok
    zathura # pdf viewer
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/mnt/media/Code/";
    SECURITY_PROJECT = "/mnt/media/Code/K2O2/security-management";
  };
}
