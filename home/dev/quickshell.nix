{ inputs, pkgs, system, ... }: {
  home.packages = [
    inputs.quickshell.packages.${system}.default
    pkgs.kdePackages.qtdeclarative
  ];

  qt = {
    enable = true;
    # style = "";
  };
}
