{ ... }: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./nh.nix
    ./locale.nix
    ./location.nix
    ./kurukurudm.nix
    # ./sddm.nix
    # ./greetd.nix
    ./shells.nix
    ./security.nix
    ./utils.nix
  ];
}
