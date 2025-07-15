{ config, ... }:
let
  configurationLimit = toString config.boot.loader.grub.configurationLimit;
in
{
  programs.nh = {
    enable = true;
    flake = "/home/tea/hauntedcupofdotfiles";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep ${configurationLimit}";
    };
  };

}
