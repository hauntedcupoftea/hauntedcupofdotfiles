{ config
, lib
, pkgs
, ...
}: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
