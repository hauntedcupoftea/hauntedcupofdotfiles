{inputs}: final: prev: {
  # Custom packages - add new packages here
  hyprland-preview-share-picker = final.callPackage ./hyprland-preview-share-picker.nix {};
  dungeondraft = final.callPackage ./dungeondraft.nix {};
  embridge = final.callPackage ./embridge.nix {};

  # Add more packages like this:
  # my-other-package = final.callPackage ./my-other-package.nix { };
}
