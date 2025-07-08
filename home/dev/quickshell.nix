{ inputs, pkgs, system, ... }: {
  home.packages = [
    inputs.quickshell.packages.${system}.default
    pkgs.qmlls
  ];
}
