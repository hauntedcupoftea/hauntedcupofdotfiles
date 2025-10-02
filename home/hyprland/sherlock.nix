{pkgs, ...}: {
  programs.sherlock = {
    package = pkgs.sherlock-launcher;
    enable = true;
    systemd.enable = true;
    aliases = {
      "NixOS Wiki" = {
        exec = "zen https://nixos.wiki/index.php?search=%s";
        icon = "nixos";
        keywords = "nix wiki docs";
        name = "NixOS Wiki";
      };
    };
  };
}
