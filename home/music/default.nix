{ pkgs, ... }: {
  imports = [
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    cava
  ];
}
