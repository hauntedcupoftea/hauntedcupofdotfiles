{inputs}: final: prev: {
  # Custom packages - add new packages here
  dungeondraft = final.callPackage ./dungeondraft.nix {};
  embridge = final.callPackage ./embridge.nix {};
  hauntedcupof-nvim = final.callPackage ./nvf {inherit inputs;};
  # Add more packages like this:
  # my-other-package = final.callPackage ./my-other-package.nix { };
}
