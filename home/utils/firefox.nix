{ ... }: {
  programs.firefox = {
    enable = true;
    profiles.default.extensions.force = true;
  };
}
