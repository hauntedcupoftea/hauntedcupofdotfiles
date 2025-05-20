{pkgs, ...}: {
  home.packages = with pkgs; [
    yarn-berry
    nodejs
    typescript
    nodePackages.typescript-language-server # TypeScript LSP
    nodePackages.prettier # Formatter for TS, JS, JSON, MD, etc.
  ];
}
