{...}: {
  xdg.desktopEntries.teamviewer = {
    name = "TeamViewer";
    exec = "env QT_STYLE_OVERRIDE= teamviewer";
    icon = "teamviewer";
    comment = "Remote control and meeting solution";
    categories = ["Network" "RemoteAccess"];
    terminal = false;
    type = "Application";
  };

  programs.fish.shellAliases = {
    teamviewer = "env QT_STYLE_OVERRIDE= teamviewer";
  };
}
