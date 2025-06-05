{ config
, lib
, pkgs
, ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      nix_shell = {
        impure_msg = "󱄅";
        pure_msg = "󱄅";
      };
    };
  };
}
