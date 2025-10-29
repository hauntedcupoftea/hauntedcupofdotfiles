{
  description = "hauntedcupoftea's hauntedcupofdotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nh.url = "github:nix-community/nh";
    flake-parts.url = "github:hercules-ci/flake-parts";

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nix-gaming.url = "github:fufexan/nix-gaming";
    hyprland.url = "github:hyprwm/Hyprland";
    walker.url = "github:abenz1267/walker";
    rust-overlay.url = "github:oxalica/rust-overlay";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:hauntedcupoftea/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    kurukurubar = {
      url = "github:Rexcrazy804/Zaphkiel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    nix-on-droid,
    rust-overlay,
    home-manager,
    ...
  }: let
    customOverlay = import ./pkgs {inherit inputs;};

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlays.default
          customOverlay
        ];
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      # TODO: change this to callpackage to make this file smaller
      perSystem = {system, ...}: let
        pkgs = mkPkgs system;
      in {
        _module.args.pkgs = pkgs;
        packages = {
          dungeondraft = pkgs.dungeondraft;
          hyprland-preview-share-picker = pkgs.hyprland-preview-share-picker;
          default = pkgs.dungeondraft;
        };
      };

      flake = {
        nixosConfigurations = {
          "Anand-GE66-Raider" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            pkgs = import nixpkgs {
              config.allowUnfree = true;
              system = "x86_64-linux";
              overlays = [
                rust-overlay.overlays.default
                customOverlay
              ];
            };
            modules = [
              ./hosts/ge66-raider
            ];
          };
        };

        nixOnDroidConfigurations = {
          default = nix-on-droid.lib.nixOnDroidConfiguration {
            modules = [
              ./hosts/tab-s8-plus
            ];
            extraSpecialArgs = {
              inherit inputs;
            };
            pkgs = import nixpkgs {
              config.allowUnfree = true;
              system = "aarch64-linux";
              overlays = [
                nix-on-droid.overlays.default
                rust-overlay.overlays.default
              ];
            };

            # set path to home-manager flake
            home-manager-path = home-manager.outPath;
          };
        };
      };
    };
}
