{pkgs, ...}: {
  vim = {
    # ── Extra plugins ──────────────────────────────────────────────────────
    startPlugins = [
      pkgs.vimPlugins.promise-async # nvim-ufo dep
      # pkgs.vimPlugins.refactoring-nvim
    ];

    # refactoring.nvim: extract function/variable, inline variable
    # luaConfigRC.refactoring = ''
    #   require('refactoring').setup({})
    # '';

    # mini.ai: extended textobjects — mi( ma( mi" ma` mif mia etc.
    mini.ai = {
      enable = true;
      setupOpts = {
        n_lines = 500;
        custom_textobjects = {
          # treesitter-aware textobjects: f=function, c=class, a=argument
          f.__raw = ''
            require('mini.ai').gen_spec.treesitter({
              a = '@function.outer', i = '@function.inner'
            })
          '';
          c.__raw = ''
            require('mini.ai').gen_spec.treesitter({
              a = '@class.outer', i = '@class.inner'
            })
          '';
          a.__raw = ''
            require('mini.ai').gen_spec.treesitter({
              a = '@parameter.outer', i = '@parameter.inner'
            })
          '';
        };
      };
    };

    # mini.surround: sa=add, sd=delete, sr=replace  e.g. saiw( sr("
    mini.surround = {
      enable = true;
      setupOpts.mappings = {
        add = "sa";
        delete = "sd";
        replace = "sr";
        find = "sf";
        find_left = "sF";
        highlight = "sh";
        update_n_lines = "sn";
      };
    };

    # nvim-treesitter-textobjects: structural movement + <A-o>/<A-i> selection
    treesitter.textobjects = {
      enable = true;
      setupOpts = {
        textobjects = {
          select = {
            enable = true;
            lookahead = true;
          };
          move = {
            enable = true;
            set_jumps = true;
            goto_next_start = {
              "[']f']" = "@function.outer";
              "[']c']" = "@class.outer";
              "[']a']" = "@parameter.inner";
            };
            goto_prev_start = {
              "['[f']" = "@function.outer";
              "['[c']" = "@class.outer";
              "['[a']" = "@parameter.inner";
            };
          };
          swap = {
            enable = true;
            swap_next = {"<leader>sp" = "@parameter.inner";};
            swap_previous = {"<leader>sP" = "@parameter.inner";};
          };
        };
      };
    };
  };
}
