{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    loginShellInit = "";
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      starship init fish | source # start starship
    '';
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch";
      nix-gc = "sudo nix-collect-garbage -d";
    };
  };
}
