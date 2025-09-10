{pkgs, ...}: {
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
    geckodriver # Selenium-like browser automation for Firefox
    zrok # self hosted ngrok
    zathura # PDF viewer
    gh # GitHub-cli
    figma-linux # UI design
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/shared/Code/";
    SECURITY_PROJECT = "/shared/Code/K2O2/security-management";
  };
}
