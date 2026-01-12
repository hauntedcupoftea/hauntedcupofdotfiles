{...}: {
  xdg.desktopEntries.TeamViewer = {
    name = "TeamViewer (wrapped)";
    exec = "env QT_STYLE_OVERRIDE= teamviewer";
    icon = "TeamViewer";
    comment = "Remote control and meeting solution";
    categories = ["Network" "RemoteAccess"];
    terminal = false;
    type = "Application";
  };

  programs.fish.shellAliases = {
    teamviewer = "env QT_STYLE_OVERRIDE= teamviewer";
  };
}
