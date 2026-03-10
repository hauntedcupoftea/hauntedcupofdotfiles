{pkgs, ...}: let
  # pixel.nvim — maps every highlight group to ANSI slots 0-15.
  # Your terminal palette (wallust locally, Android theme over SSH) drives all
  # colors with zero per-host or per-app color config needed.
  pixel-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "pixel-nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "bjarneo";
      repo = "pixel.nvim";
      rev = "main";
      hash = "sha256-D4o5IkLsW4iq6ceeCHKHCNwxVpEV8fYPbpms+J7ZcJQ=";
    };
  };
in {
  vim = {
    # ── Theme ──────────────────────────────────────────────────────────────
    theme.enable = false; # handled by pixel.nvim below

    ui.nvim-ufo = {
      enable = true;
      setupOpts = {
        foldlevel = 99;
        foldlevelstart = 99;
        foldenable = true;
      };
    };

    extraPlugins.pixel-nvim = {
      package = pixel-nvim;
      setup = "";
    };

    luaConfigRC.colorscheme = ''
      vim.cmd('colorscheme pixel')
    '';

    ui = {
      borders.enable = true;
      colorizer.enable = true; # highlight #hex colour codes inline
      illuminate.enable = true; # highlight other uses of word under cursor
      noice = {
        enable = true;
        setupOpts = {
          presets = {
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = true;
          };
          views = {
            cmdline_popup = {
              border.style = "rounded";
              win_options.winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
            };
            popupmenu.border.style = "rounded";
          };
        };
      };
      modes-nvim.enable = false;
      smartcolumn = {
        enable = true;
        setupOpts.colorcolumn = "100";
      };
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true; # <leader>ns symbol navigation popup
      };
    };

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        notifier = {
          enabled = true;
          style = "fancy";
        };
        input.enabled = true;
        explorer.enabled = true;
        picker.enabled = true;
        styles = {
          notification = {
            border = "rounded";
            wo.winblend = 0;
          };
          input = {
            border = "rounded";
            wo.winblend = 0;
          };
        };
      };
    };

    # Fix float backgrounds — pixel.nvim maps to cterm slots,
    # so we clear the background on all float-adjacent groups
    luaConfigRC.float-highlights = ''
      vim.api.nvim_set_hl(0, 'NormalFloat',   { ctermbg = 'NONE', ctermfg = 'NONE' })
      vim.api.nvim_set_hl(0, 'FloatBorder',   { ctermbg = 'NONE', ctermfg = 4 })
      vim.api.nvim_set_hl(0, 'WhichKeyFloat', { ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'WhichKeyBorder',{ ctermbg = 'NONE', ctermfg = 4 })
      vim.api.nvim_set_hl(0, 'WhichKeyNormal',{ ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'Pmenu',         { ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'PmenuSel',      { ctermbg = 4, ctermfg = 0 })
      vim.api.nvim_set_hl(0, 'Normal',   { ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NonText',  { ctermbg = 'NONE' })
    '';

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      indent-blankline.enable = true;
    };

    # ── Statusline ─────────────────────────────────────────────────────────
    statusline.lualine = {
      enable = true;
      setupOpts.options = {
        theme = "auto"; # reads terminal ANSI colors
        section_separators = "";
        component_separators = "│";
        globalstatus = true; # one statusline across all splits
      };
      setupOpts.sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff"];
        lualine_c = [
          {
            name = "filename";
            extraConfig.path = 1;
          } # relative path
        ];
        lualine_x = ["diagnostics" "filetype"];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
    };

    tabline.nvimBufferline.enable = true;

    # ── Misc UI ────────────────────────────────────────────────────────────
    binds.whichKey.enable = true;
    notify.nvim-notify.enable = true;
  };
}
