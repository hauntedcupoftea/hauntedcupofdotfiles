{ pkgs, ... }: {
  home.packages = with pkgs; [
    uv # package manager
    basedpyright # Microsoft's Pyright LSP
    ruff # Code linter + formatter
  ];
}
