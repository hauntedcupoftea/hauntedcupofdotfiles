{pkgs, ...}: {
  vim = {
    theme.enable = false;

    extraPlugins.mini-base16 = {
      package = pkgs.vimPlugins.mini-base16;
      setup = "";
    };

    luaConfigRC.colorscheme = ''
      local function load_colors()
        local ok, colors = pcall(dofile, vim.fn.expand('~/.config/nvim/wallust-colors.lua'))
        if not ok or not colors then return end

        require('mini.base16').setup({
          palette = {
            base00 = colors.background,
            base01 = colors.color0,
            base02 = colors.color8,
            base03 = colors.color9,
            base04 = colors.color7,
            base05 = colors.foreground,
            base06 = colors.color7,
            base07 = colors.color15,
            base08 = colors.color1,
            base09 = colors.color3,
            base0A = colors.color11,
            base0B = colors.color2,
            base0C = colors.color6,
            base0D = colors.color4,
            base0E = colors.color5,
            base0F = colors.color13,
          },
        })

        -- Transparency + highlight fixes
        local transparent = {
          "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
          "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
          "StatusLine", "StatusLineNC", "TabLine", "TabLineFill", "TabLineSel",
          "WinBar", "WinBarNC", "SignColumn", "LineNr", "LineNrAbove",
          "LineNrBelow", "CursorLineNr", "FoldColumn", "Folded",
          "EndOfBuffer", "ColorColumn", "CursorLine",
          "WhichKey", "WhichKeyGroup", "WhichKeyDesc", "WhichKeySeparator",
          "WhichKeyFloat", "WhichKeyBorder", "WhichKeyValue",
        }
        for _, group in ipairs(transparent) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end

        vim.api.nvim_set_hl(0, "FloatBorder",  { fg = colors.color8, bg = "NONE" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.color8, bg = "NONE" })
        vim.api.nvim_set_hl(0, "LineNr",       { fg = colors.color8, bg = "NONE" })
        vim.api.nvim_set_hl(0, "Visual",       { bg = colors.color8, fg = colors.foreground })
        vim.api.nvim_set_hl(0, "Search",       { bg = colors.color3, fg = colors.background })
        vim.api.nvim_set_hl(0, "IncSearch",    { bg = colors.color6, fg = colors.background })
        vim.api.nvim_set_hl(0, "MatchParen",   { bg = colors.color8, fg = colors.foreground, bold = true })
      end

      load_colors()

      local w = vim.uv.new_fs_event()
      local path = vim.fn.expand('~/.config/nvim/wallust-colors.lua')

      local function watch()
        w:start(path, {}, vim.schedule_wrap(function()
          w:stop()
          load_colors()
          watch() -- debounce by restarting after handling
        end))
      end

      watch()
    '';

    ui = {
      borders.enable = true;
      colorizer.enable = true; # highlight #hex colour codes inline
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
        bufdelete.enable = true;
        explorer.enabled = true;
        picker.enabled = true;

        scratch.enabled = true;

        git.enabled = true;
        gitbrowse.enabled = true;

        dashboard = {
          enabled = true;
          sections = [
            {section = "header";}
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              indent = 2;
              padding = 1;
            }
            {
              icon = " ";
              title = "Projects";
              section = "projects";
              indent = 2;
              padding = 1;
            }
          ];
          preset.keys = [
            {
              icon = " ";
              key = "e";
              desc = "Explorer";
              action = ":lua Snacks.explorer()";
            }
            {
              icon = " ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
            }
            {
              icon = " ";
              key = "r";
              desc = "Recent Files";
              action = ":lua Snacks.dashboard.pick('oldfiles')";
            }
            {
              icon = " ";
              key = "g";
              desc = "Find Text";
              action = ":lua Snacks.dashboard.pick('live_grep')";
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };

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

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      indent-blankline.enable = true;
    };

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

    binds.whichKey.enable = true;
    notify.nvim-notify.enable = true;
  };
}
