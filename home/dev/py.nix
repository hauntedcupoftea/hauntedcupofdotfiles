{pkgs, ...}: {
  # The Astral Tooling
  home.packages = with pkgs; [
    uv # package manager
    ty # Microsoft's Pyright LSP
    ruff # Code linter + formatter
    python3 # python
  ];
}
