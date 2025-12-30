{pkgs, ...}: {
  home.packages = with pkgs; [freecad godot];
}
