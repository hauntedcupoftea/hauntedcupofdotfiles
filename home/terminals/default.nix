{ ... }: {
  imports = [
    ./kitty.nix
    ./alacritty.nix
    ./zellij.nix # multiplexor
  ];
}
