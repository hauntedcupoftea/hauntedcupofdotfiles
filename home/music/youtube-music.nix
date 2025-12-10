{pkgs, ...}: {
  home.packages = with pkgs; [ytmdesktop kdePackages.audiotube];
}
