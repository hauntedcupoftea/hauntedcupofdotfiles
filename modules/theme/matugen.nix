{ config, pkgs, ... }: {
  imports = [ ];

  config = {
    matugen = {
      enable = true;
      image = ../../wallpapers/malenia.jpg;
    };
  };
}
