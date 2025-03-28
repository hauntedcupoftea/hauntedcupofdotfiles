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
      style = "mocha";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      ts.enable = true;
      rust.enable = true;
      python.enable = true;
      md.enable = true;
    };
  };
}
