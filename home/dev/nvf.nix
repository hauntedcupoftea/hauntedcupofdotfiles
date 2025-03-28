{
  inputs,
  pkgs,
  lib,
  ...
}: {
  vim.package = inputs.neovim-overlay.packages.${pkgs.system}.neovim;
  vim = {
    theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha"
    }

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
  }
}
