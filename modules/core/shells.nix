{pkgs, ...}: {
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  programs.bash = {
    interactiveShellInit = ''
      if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
          SHELL=${pkgs.fish}/bin/fish exec fish
      fi
    '';
  };

  environment.shellAliases = {
    l = null;
    ll = null;
    ls = null;
  };
}
