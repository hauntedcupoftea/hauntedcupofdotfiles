{...}: {
  vim = {
    viAlias = true;
    vimAlias = true;

    # Completion
    autocomplete.blink-cmp = {
      enable = true;
      setupOpts.signature.enabled = true; # builtin signature popup
      setupOpts.keymap.preset = "default";
      setupOpts.keymap."<C-Space>" = ["show" "show_documentation" "hide_documentation"];
    };
    mini.pairs.enable = true;

    # Treesitter
    treesitter = {
      enable = true;
      autotagHtml = true; # auto close/rename JSX + HTML tags
    };

    utility.yazi-nvim = {
      enable = true;
      setupOpts.open_for_directories = true; # hijack netrw directory opens
      mappings.openYazi = "<leader>y";
      mappings.openYaziDir = "<leader>Y";
      mappings.yaziToggle = "<leader>yt";
    };

    # Project root detection
    projects.project-nvim = {
      enable = true;
      setupOpts.detection_methods = ["pattern" "lsp"];
      setupOpts.patterns = [
        "deno.json"
        "deno.jsonc"
        "package.json"
        ".git"
        "flake.nix"
      ];
    };

    # File tree
    filetree.neo-tree = {
      enable = false;
      setupOpts = {
        close_if_last_window = true;
        filesystem.filtered_items = {
          hide_dotfiles = false;
          hide_gitignored = false;
        };
      };
    };

    # Git
    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = true; # stage/reset hunk via code action
      git-conflict = {
        enable = true;
      };
    };

    # Misc
    comments.comment-nvim.enable = true;
    undoFile.enable = true;

    # Editor options
    options = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      mouse = "a";
      signcolumn = "yes";
      splitright = true;
      splitbelow = true;
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      updatetime = 50;
      timeoutlen = 300;
      foldlevel = 99;
      foldlevelstart = 99;
    };

    luaConfigRC.eob = ''
      vim.opt.fillchars:append({ eob = " " })
    '';

    luaConfigRC.focus-redraw = ''
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          vim.cmd("redraw!")
        end,
      })
    '';

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
