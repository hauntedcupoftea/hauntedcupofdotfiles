{
  description = "hauntedcupoftea's hauntedcupofdotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "ge66-raider" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/ge66-raider
        ];
      };
    };
  };
}
