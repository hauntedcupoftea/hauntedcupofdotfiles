{pkgs, ...}: {
  home.packages = with pkgs; [
    deno # I will slowly transition to this
    nodejs
    pnpm
  ];
}
