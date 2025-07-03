{ ... }: {
  imports = [
    ./audio.nix
    ./filesystems.nix # something breaks here potentially
    ./nvidia.nix
    ./power.nix
    ./razer.nix
  ];
}
