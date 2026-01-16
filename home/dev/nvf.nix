{inputs, ...}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;

        lsp = {
          enable = true;

          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = false; # conflicts with blink in maximal
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          harper-ls.enable = true;
        };

        snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false;
          neogit.enable = true;
        };

        minimap = {
          codewindow.enable = true;
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          icon-picker.enable = true;
          surround.enable = true;
          multicursors.enable = true;
          smart-splits.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };
          images = {
            image-nvim.enable = false;
            img-clip.enable = true;
          };
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # fish.enable = true; i am hurt
          bash.enable = true;
          css.enable = true;
          html.enable = true;
          json.enable = true;
          toml.enable = true;
          markdown.enable = true;
          nix.enable = true;
          ts.enable = true;
          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
          };
          python.enable = true;
          svelte.enable = true;
          qml.enable = true;
        };
        presence.neocord.enable = true;
      };
    };
  };
}
