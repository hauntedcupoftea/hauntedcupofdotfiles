{ inputs, pkgs, ... }: {
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
    pkgs.kdePackages.qtdeclarative
  ];

  qt = {
    enable = true;
    # catppuccin says we need this
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };

  # home.sessionVariables = {
  #   QML2_IMPORT_PATH = "/run/current-system/sw/lib/qt-6/qml/";
  # };
}
