{inputs, ...}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = false;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = true;
          lightbulb.enable = false; # Disable to avoid potential ts_utils issues
          trouble.enable = true;
          lspSignature.enable = false;
          harper-ls.enable = true; # Grammar/spell checking LSP
        };

        autocomplete.blink-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;

        statusline.lualine = {
          enable = true;
        };

        tabline.nvimBufferline.enable = true;

        filetree.neo-tree.enable = true;
        telescope.enable = true;

        treesitter.context.enable = true;
        binds.whichKey.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false;
        };

        notify.nvim-notify.enable = true;

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
        };

        comments.comment-nvim.enable = true;

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          indent-blankline.enable = true;
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          bash.enable = true;
          css.enable = true;
          html.enable = true;
          json.enable = true;
          toml.enable = true;
          markdown.enable = true;
          nix.enable = true;
          ts.enable = true;
          python.enable = true;
          svelte.enable = true;
          qml.enable = true;

          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
          };
        };
      };
    };
  };
}
