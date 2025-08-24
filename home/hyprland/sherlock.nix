{pkgs, ...}: {
  programs.sherlock = {
    package = pkgs.sherlock-launcher;
    enable = true;
    systemd.enable = true;
    aliases = {
      "NixOS Wiki" = {
        exec = "firefox https://nixos.wiki/index.php?search=%s";
        icon = "nixos";
        keywords = "nix wiki docs";
        name = "NixOS Wiki";
      };
    };
  };
}
