{...}: {
  imports = [
    ./nvidia.nix
    ./audio.nix
    ./filesystems.nix # something breaks here potentially
  ];
}
