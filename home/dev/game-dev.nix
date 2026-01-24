{pkgs, ...}: let
  # https://github.com/NixOS/nixpkgs/issues/468456
  freecadWayland = pkgs.symlinkJoin {
    name = "freecad-wayland-fix";
    paths = [
      pkgs.freecad-wayland
    ];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/FreeCAD \
        --prefix MESA_LOADER_DRIVER_OVERRIDE : zink \
        --prefix __EGL_VENDOR_LIBRARY_FILENAMES : ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
    '';
  };
in {
  home.packages = with pkgs; [
    freecadWayland
    godot
  ];
}
