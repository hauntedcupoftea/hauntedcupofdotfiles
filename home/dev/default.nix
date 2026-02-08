{pkgs, ...}: {
  imports = [
    ./git.nix
    # ./firefox.nix
    ./direnv.nix
    ./nvf.nix
    ./helix.nix
    ./py.nix
    ./podman.nix
    ./quickshell.nix
    ./game-dev.nix
    ./rust.nix # only LSP
    ./teamviewer.nix
    ./ts.nix
    ./typst.nix
    ./zed-editor.nix
  ];

  home.packages = with pkgs; [
    requestly # another api testing tool that's kinda an industry standard?
    bruno # api testing tool that works on plaintext
    zrok # self hosted ngrok
    zathura # PDF viewer
    gh # GitHub-cli
    sql-studio # dbms
  ];

  # my preferred, feel free to change:
  home.sessionVariables = {
    DEV_WORKDIR = "/shared/Code/";
    SECURITY_PROJECT = "/shared/Code/K2O2/security-management";
  };
}
