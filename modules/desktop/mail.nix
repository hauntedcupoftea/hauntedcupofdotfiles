{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    package =
      (import pkgs.path {
        inherit (pkgs) system;
        config.allowUnfree = true;
        # cudaSupport intentionally omitted
      }).thunderbird;
  };
}
