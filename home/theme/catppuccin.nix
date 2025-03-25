{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "blue";
  };
}
