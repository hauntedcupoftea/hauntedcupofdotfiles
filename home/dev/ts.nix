{pkgs, ...}: {
  home.packages = with pkgs; [
    yarn-berry
    nodejs
    typescript
  ];
}
