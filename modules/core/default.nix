{...}: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./locale.nix
    ./sddm.nix
    ./shells.nix
    ./security.nix
    ./utils.nix
  ];
}
