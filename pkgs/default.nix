{inputs}: final: prev: {
  # Custom packages - add new packages here
  dungeondraft = final.callPackage ./dungeondraft.nix {};
  embridge = final.callPackage ./embridge.nix {};

  # Add more packages like this:
  # my-other-package = final.callPackage ./my-other-package.nix { };
}
