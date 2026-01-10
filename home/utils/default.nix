{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./eza.nix
    ./fzf.nix
    ./misc
    ./yazi.nix
    ./zoxide.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    lm_sensors # sensor data
    nload # network traffic
  ];
}
