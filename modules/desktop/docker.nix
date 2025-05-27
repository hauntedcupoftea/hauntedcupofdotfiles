{ ... }: {
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    enableNvidia = true;
  };
}
