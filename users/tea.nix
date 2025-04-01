{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    # inputs.nvf.homeManagerModules.default # enabling this makes home manager not work?
  ];

  # Define a user account
  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs;
    };
    users.tea = {
      imports = [
        ../home
        inputs.catppuccin.homeModules.catppuccin
        inputs.nvf.homeManagerModules.default
      ];
      home.username = "tea";
      home.homeDirectory = "/home/tea";
      home.stateVersion = "24.11"; # DO NOT CHANGE
      programs.home-manager.enable = true;
    };
  };

  nix.settings.trusted-users = ["tea"];
}
