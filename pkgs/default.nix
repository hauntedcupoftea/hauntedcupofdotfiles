{ inputs }:

final: prev:
let
  # Helper function to call package files with consistent arguments
  callPackage = path: args: final.callPackage path ({ inherit inputs; } // args);
in
{
  hyprland-preview-share-picker = callPackage ./hyprland-preview-share-picker.nix { };

  # Add more packages like this:
  # my-other-package = callPackage ./my-other-package.nix { };
}
