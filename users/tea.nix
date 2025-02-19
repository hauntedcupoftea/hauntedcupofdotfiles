{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {inherit inputs;};
    users.tea = {
      imports = [../home];
      home.username = "tea";
      home.homeDirectory = "/home/tea";
      home.stateVersion = "24.11";
      programs.home-manager.enable = true;
    };
  };

  # Define a user account
  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  nix.settings.trusted-users = ["tea"];
}
