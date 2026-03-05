{...}: {
  programs.direnv = {
    enable = false;
    enableFishIntegration = true;
    nix-direnv = {enable = true;};
  };
}
