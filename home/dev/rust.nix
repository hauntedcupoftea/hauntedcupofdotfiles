{ pkgs, ... }: {
  home.packages = with pkgs; [
    rustup
    clang # Provides the 'cc' linker (clang)
    pkg-config
  ];
}
