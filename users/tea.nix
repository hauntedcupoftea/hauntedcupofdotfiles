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
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Home manager configuration for user "tea"
  home-manager.users.tea = import ../home;
}
