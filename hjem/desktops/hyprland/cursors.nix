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
        "Icon Theme".Inherits = "Bibata-Modern-Classic";
      };
    };
  };
  environment.sessionVariables = {
    HYPRCURSOR_THEME = "Bibata-modern";
    HYPRCURSOR_SIZE = 28;
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 28;
    XCURSOR_PATH = ["${pkgs.bibata-cursors}/share/icons"];
  };
  packages = [
    (pkgs.callPackage "${inputs.niqspkgs}/pkgs/bibata-hyprcursor/package.nix" {
      variant = "modern";
    })
    pkgs.bibata-cursors
  ];
}
