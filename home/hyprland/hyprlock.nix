{pkgs, ...}: {
    programs.hyprlock = {
        enable = true;
        package = pkgs.hyprlock;
    }
}