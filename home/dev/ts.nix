{pkgs, ...}: {
  home.packages = with pkgs; [
    yarn-berry
    deno # I will slowly transition to this
    nodejs
    typescript
    nodePackages.typescript-language-server # TypeScript LSP
  ];
}
