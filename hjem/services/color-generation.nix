{pkgs, ...}: {
  hjem.users.tea.packages = with pkgs; [
    matugen # material you
    wallust # base16
  ];
}
