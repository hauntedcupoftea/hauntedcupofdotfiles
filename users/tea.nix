{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    inputs.hjem.nixosModules.default
    ../hjem # figure out how to do this under users like hm, maybe.
  ];

  # Define a user account
  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish; # we will use the bash fix
    extraGroups = ["networkmanager" "wheel" "openrazer" "plugdev" "gamemode" "input" "dialout"];
    packages = [];
  };

  hjem = {
    extraModules = [inputs.hjem-rum.hjemModules.default];
    users.tea = {
      enable = true;
      user = "tea";
      directory = "/home/tea";
    };
    clobberByDefault = true;
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

  nix.settings.trusted-users = ["tea"];
}
