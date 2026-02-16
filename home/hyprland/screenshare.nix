{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
