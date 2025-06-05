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
    , astal
    , ags
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
        name = "ags-dev-shell";
        packages = [
          ags.packages.${system}.default # The ags CLI tool
          pkgs.wrapGAppsHook
          pkgs.gobject-introspection
        ] ++ (with astal.packages.${system}; [
          astal3 # Assuming astal flake provides 'astal3'
          io # Assuming astal flake provides 'io'
          # any other packages from astal needed for development
        ]);

        shellHook = ''
          # Check if we are in an interactive shell, not already in fish, and fish is available
          if [ -t 0 ] && [ -z "$FISH_VERSION" ] && command -v fish &>/dev/null; then
            echo "Switching to fish shell..."
            exec fish # Replace the current shell with fish
          else
            # Fallback for non-interactive shells or if fish isn't found/already running
            echo "Entered AGS development shell (current: $SHELL)."
            echo "AGS CLI, Astal libraries, and other tools are now available."
          fi
        '';
      };

      # TODO: use this bundler once ags bar is ready.
      # packages.${system}.myAgsApp = pkgs.stdenvNoCC.mkDerivation rec {
      #   name = "hauntedcupofbar";
      #   version = "0.1.0"; # Or your desired version

      #   src = ~/code/ags-nc-bar; # Source directory for your AGS application (e.g., where app.ts is)

      #   nativeBuildInputs = [
      #     ags.packages.${system}.default # AGS CLI
      #     pkgs.wrapGAppsHook
      #     pkgs.gobject-introspection
      #   ];

      #   buildInputs = with astal.packages.${system}; [
      #     astal3
      #     io
      #     # any other runtime dependencies from astal
      #   ];

      #   installPhase = ''
      #     mkdir -p $out/bin
      #     # Ensure app.ts is found, adjust path if src is a subdirectory, e.g., ags bundle $src/app.ts ...
      #     ags bundle app.ts $out/bin/${name}
      #   '';
      # };
    };
}
