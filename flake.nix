{
  description = "hauntedcupoftea's hauntedcupofdotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hypr-contrib.url = "github:hyprwm/contrib";

    hyprpicker.url = "github:hyprwm/hyprpicker";

    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland.url = "github:hyprwm/Hyprland";

    walker.url = "github:abenz1267/walker";

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

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , catppuccin
    , nvf
    , zen-browser
    , ags
    , astal
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        "ge66-raider" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/ge66-raider
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (ags.packages.${system}.default.override {
            extraPackages = with astal.packages.${system}; [
              # Core Libraries
              io
              astal4

              # All App Libraries
              auth
              battery
              bluetooth
              cava
              hyprland
              mpris
              network
              notifd
              powerprofiles
              tray
              wireplumber
            ];
          })
          # You can still add other non-AGS tools here if you need them
          pkgs.fish
        ];

        shellHook = ''
          echo "✅ Entered Correct AGS/Astal Development Environment"
          echo "   - The 'ags' CLI is now available."
          echo "   - All Astal modules are ready for use."
          echo "   - LSP autocompletion is fully configured."
        '';
      };
    };
}
