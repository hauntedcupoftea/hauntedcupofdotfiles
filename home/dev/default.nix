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
  ];

  home.packages = with pkgs; [
    # misc packages
    bruno # api testing tool that works on plaintext
    geckodriver # selenium-like browser automation for firefox
    zrok # self hosted ngrok
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/mnt/media/Code/";
    SECURITY_PROJECT = "/mnt/media/Code/K2O2/security-management";
  };
}
