{ pkgs, ... }: {
  home.packages = with pkgs; [
    uv # package manager
    pyright # Microsoft's Pyright LSP
    ruff # Code linter + formatter
  ];
}
