{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # https://gitlab.com/fazzi/nixohess/-/blob/main/modules/programs/hyprland/cursor.nix
  xdg = {
    data.files."icons/default/index.theme" = {
      generator = lib.generators.toINI {};
      value = {
        "Icon Theme".Inherits = "Bibata-Original-Classic";
      };
    };
  };
  packages = [
    (pkgs.callPackage "${inputs.niqspkgs}/pkgs/bibata-hyprcursor/package.nix" {
      variant = "modern";
    })
    pkgs.bibata-cursors
  ];
}
