{pkgs, ...}: {
  home.packages = with pkgs; [
    ags
    gtk4
    gtk4-layer-shell
    nodePackages.typescript
    gobject-introspection
    gjs
    nodejs
  ];
}
