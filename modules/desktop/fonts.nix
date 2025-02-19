{
  config,
  lib,
  pkgs,
  ...
}: {
  # Add nerdfonts
  fonts.packages = with pkgs; [
    nerdfonts
  ];
}
