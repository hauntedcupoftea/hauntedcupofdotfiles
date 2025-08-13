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

  home.packages = with pkgs; [
    wf-recorder # screenrec
    slurp # region selector
    lm_sensors
  ];
}
