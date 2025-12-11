{pkgs, ...}: {
  home.packages = with pkgs; [ytmdesktop];

  # desktop file that fixes safeStorage
  xdg.desktopEntries.ytmdesktop = {
    name = "YouTube Music Desktop App";
    genericName = "Desktop App for YouTube Music";
    exec = "ytmdesktop --password-store=\"gnome-libsecret\"";
    icon = "ytmdesktop";
    terminal = false;
    type = "Application";
    categories = ["AudioVideo" "Audio"];
    mimeType = ["x-scheme-handler/ytmd"];
    startupNotify = true;
    settings = {
      StartupWMClass = "YouTube Music Desktop App";
    };
  };
}
