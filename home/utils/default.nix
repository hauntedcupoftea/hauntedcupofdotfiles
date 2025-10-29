{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./eza.nix
    ./fzf.nix
    ./misc
    ./yazi.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    lm_sensors # sensor data
  ];
}
