{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Define a user account
  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Home manager configuration for user "tea"
  home-manager.users.tea = import ../home;
}
