{
  inputs,
  pkgs,
  ...
}: let
  awww = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
in {
  hjem.users.tea.packages = [awww];
}
