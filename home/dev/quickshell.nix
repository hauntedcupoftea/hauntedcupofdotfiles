{ inputs, pkgs, ... }: {
  home.packages = with pkgs.kdePackages; [
    inputs.quickshell.packages.${pkgs.system}.default
    qtdeclarative
    qt5compat
    qtstyleplugin-kvantum
    qtsvg
  ];

  qt = {
    enable = true;
  };

  catppuccin.kvantum.enable = false; # god i hate this flake someone get me out
}
