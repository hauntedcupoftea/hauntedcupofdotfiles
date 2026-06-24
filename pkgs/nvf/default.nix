{
  inputs,
  pkgs,
}:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [
    ./lsp.nix
    ./ui.nix
    ./plugins.nix
    ./editor.nix
    ./keymaps.nix
    ./ai.nix
  ];
}).neovim
