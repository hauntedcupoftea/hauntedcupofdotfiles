{ pkgs
, inputs
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];

  # Define a user account
  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "openrazer" "plugdev" "gamemode" "input" ];
    packages = [ ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs;
      system = "x86_64-linux";
    };
    users.tea = {
      imports = [
        ../home
        inputs.catppuccin.homeModules.catppuccin
      ];
      home = {
        username = "tea";
        homeDirectory = "/home/tea";
        stateVersion = "24.11"; # DO NOT CHANGE
      };
      programs.home-manager.enable = true;
    };
  };

  nix.settings.trusted-users = [ "tea" ];
}
