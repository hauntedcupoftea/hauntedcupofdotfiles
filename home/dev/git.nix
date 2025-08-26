{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    gh
    # yaziPlugins.gitui
  ];

  programs.gitui = {
    enable = false; # https://github.com/gitui-org/gitui/issues/2702
  };
}
