{
  config,
  lib,
  pkgs,
  ...
}: {
  # Add nerdfonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
  ];
}
