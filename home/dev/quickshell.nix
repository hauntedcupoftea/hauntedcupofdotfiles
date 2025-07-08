{ inputs, pkgs, system, ... }: {
  home.packages = [
    inputs.quickshell.packages.${system}.default
    pkgs.kdePackages.qtdeclarative
  ];

  qt = {
    enable = true;
    # catppuccin says we need this
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
}
