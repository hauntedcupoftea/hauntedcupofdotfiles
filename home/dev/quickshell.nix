{ inputs, pkgs, ... }: {
  home.packages = with pkgs.kdePackages; [
    inputs.quickshell.packages.${pkgs.system}.default
    qtdeclarative
    qt5compat
    qtstyleplugin-kvantum
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
