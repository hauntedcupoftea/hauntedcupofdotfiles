{...}: {
  imports = [
    ../../home/shell
    ../../home/utils
    ../../home/dev/helix.nix
    ../../home/dev/py.nix
    ../../home/dev/ts.nix
    ../../home/dev/rust.nix
    ../../home/dev/git.nix
    ../../home/terminals/zellij.nix
  ];

  programs.helix.settings = {theme = "catppuccin_mocha";};

  home.stateVersion = "24.05";
}
