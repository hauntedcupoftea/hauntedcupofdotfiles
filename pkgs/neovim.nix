{ inputs, pkgs }:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [ ./nvf-config.nix ];
}).neovim
