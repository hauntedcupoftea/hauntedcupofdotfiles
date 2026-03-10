{...}: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./nh.nix
    ./locale.nix
    ./location.nix
    # the infamous greeter war (everything changed when the greetd nation attacked)
    ./cosmic-greeter.nix
    # ./kurukurudm.nix
    # ./sddm.nix
    # ./greetd.nix

    ./ssh.nix
    ./shells.nix
    ./security.nix
    ./utils.nix
    ./undervolt.nix
  ];
}
