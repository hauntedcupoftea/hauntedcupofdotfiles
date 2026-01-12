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
    brightnessctl # brightness control
    btop # system resource monitor
    btrfs-progs # for btrfs
    desktop-file-utils # xdg utils
    fastfetch # cool sysinfo monitor
    git # version control
    inetutils # other network goodies
    lm_sensors # sensor data
    nload # network traffic
    parted # disk management
    wget2 # better wget?
  ];
}
