{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs.kdePackages; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    qtdeclarative
    qt5compat
    qtstyleplugin-kvantum
    qtsvg
  ];

  qt = {
    enable = true;
    # style.name = "kvantum";
    # platformTheme.name = "kvantum";
  };
}
