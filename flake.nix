{
  description = "hauntedcupoftea's hauntedcupofdotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nh.url = "github:nix-community/nh";

    hypr-contrib.url = "github:hyprwm/contrib";

    hyprpicker.url = "github:hyprwm/hyprpicker";

    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland.url = "github:hyprwm/Hyprland";

    walker.url = "github:abenz1267/walker";

    rust-overlay.url = "github:oxalica/rust-overlay";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , nh
    , home-manager
    , catppuccin
    , nvf
    , zen-browser
    , quickshell
    , rust-overlay
    , spicetify-nix
    , ...
    } @ inputs:
    let
      # Import custom packages overlay from pkgs directory
      customPackagesOverlay = import ./pkgs { inherit inputs; };

      # Function to create pkgs with all overlays
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlays.default
          customPackagesOverlay
        ];
      };
    in
    {
      # Add packages output for easier testing
      packages.x86_64-linux = {
        hyprland-preview-share-picker = (mkPkgs "x86_64-linux").hyprland-preview-share-picker;
        default = self.packages.x86_64-linux.hyprland-preview-share-picker;
      };

      nixosConfigurations = {
        "ge66-raider" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.overlays = [
                rust-overlay.overlays.default
                customPackagesOverlay
                (final: prev: {
                  jdk8 = final.openjdk8-bootstrap;
                })
              ];
            }
            ./hosts/ge66-raider
          ];
        };
      };
    };
}
