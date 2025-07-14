{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./eza.nix
    ./firefox.nix # only for geckodriver lol
    ./fzf.nix
    ./misc
    ./yazi.nix
    ./zoxide.nix
  ];

  home.packages = [
    pkgs.tree
  ];
}
