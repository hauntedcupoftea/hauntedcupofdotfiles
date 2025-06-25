{ ... }: {
  imports = [
    ./btop.nix
    ./firefox.nix # only for geckodriver lol
    ./fzf.nix
    ./misc
    ./yazi.nix
    ./zoxide.nix
  ];
}
