{...}: {
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  environment.shellAliases = {
    l = null;
    ll = null;
    ls = null;
  };
}
