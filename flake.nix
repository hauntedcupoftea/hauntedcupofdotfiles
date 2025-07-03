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
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , catppuccin
    , nvf
    , zen-browser
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

      packages.${system}.ags-config = pkgs.stdenvNoCC.mkDerivation {
        pname = "hauntedcupofbar";
        version = "0.0.1";

        # IMPORTANT: Your AGS code should be in a sub-folder
        # of your dotfiles repo, e.g., './ags'.
        src = ./ags;

        # These are tools needed for DEVELOPMENT and BUILDING
        nativeBuildInputs = [
          pkgs.esbuild # A modern, fast bundler for JS/TS
          pkgs.gobject-introspection # Makes GObject libs (like GTK) visible to JS
          pkgs.wrapGAppsHook # Automatically sets up paths for GTK apps
        ];

        # These are libraries needed at RUNTIME
        buildInputs = [
          pkgs.gjs # The JavaScript engine
          pkgs.gtk4
          astal.packages.${system}.io
          astal.packages.${system}.astal4
          # Add other astal libraries here as you use them, e.g.:
          # astal.packages.${system}.battery
        ];

        # This part is for when you're ready to build a final binary.
        # You can ignore it for now, but it's ready when you are.
        installPhase = ''
          mkdir -p $out/bin

          esbuild \
            --bundle src/main.js \ # Or main.ts, config.js, etc.
            --outfile=$out/bin/hauntedcupofbar \
            --format=esm \
            --platform=node \
            --external:gi://* \
            --external:file://*

          # Make the output executable
          chmod +x $out/bin/haunted-ags-bar
        '';
      };

      # 2. CREATE A DEVELOPMENT SHELL FROM THAT PACKAGE
      # This is the "cohesive development environment" you asked for.
      devShells.${system}.default = pkgs.mkShell {
        # This tells the shell to use all the inputs from your package definition.
        # This is the magic that makes everything "just work".
        inputsFrom = [ self.packages.${system}.ags-config ];

        # You can add extra tools for your dev environment here.
        packages = [
          pkgs.fish # For your preferred shell
        ];

        # No more complex shellHook needed!
        shellHook = ''
          echo "✅ Entered AGS/Astal development environment."
          echo "   Editor autocompletion (LSP) for 'gi://' and 'file://' will work automatically."
          echo "   Type 'fish' to switch to the fish shell."
        '';
      };

      # Make your final AGS config runnable with `nix run .#ags`
      apps.${system}.ags = {
        type = "app";
        program = "${self.packages.${system}.ags-config}/bin/haunted-ags-bar";
      };
    };
}
