{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    rust-analyzer # Rust Language Server (includes rustfmt)
  ];
}
