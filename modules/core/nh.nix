{ config
  #, inputs
  #, pkgs
, ...
}:
let
  configurationLimit = toString config.boot.loader.grub.configurationLimit;
in
{
  programs.nh = {
    enable = true;
    flake = "/home/tea/hauntedcupofdotfiles";
    # package = inputs.nh.packages.${pkgs.system}.default;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep ${configurationLimit}";
    };
  };

}
