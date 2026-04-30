{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nvim.lua) toLuaObject;
  # https://microsoft.github.io/language-server-protocol/specifications/specification-current#serverCapabilities
  # https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
  overrideCapabilities = attrs:
    lib.generators.mkLuaInline
    /*
    lua
    */
    ''
      function(client, initialization_result)
        if client.server_capabilities then
          client.server_capabilities = vim.tbl_deep_extend(
            "force",
            client.server_capabilities or {},
            ${toLuaObject attrs}
          )
        end
      end
    '';
in {
  vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = true;
      inlayHints.enable = true;
      trouble.enable = true;

      presets.tailwindcss-language-server.enable = true;

      servers = {
        nixd = {
          on_init = overrideCapabilities {
            # capabilities that are also provided by nil
            completionProvider = false;
            declarationProvider = false;
            definitionProvider = false;
            referencesProvider = false;
            renameProvider = false;
          };
        };

        nil = {
          on_init = overrideCapabilities {
            documentFormattingProvider = false; # we have conform.nvim
            semanticTokensProvider = false; # overrides tree-sitter comment
          };
        };
      };
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      typescript = {
        enable = true;
        lsp.servers = ["deno"];
        format.enable = false;
      };
      css = {
        enable = true;
        format.enable = false;
      };
      html = {
        enable = true;
        lsp.servers = ["emmet-ls"];
        format.enable = false;
      };
      svelte = {
        enable = true;
        format.enable = false;
      };
      json.enable = true;
      nix = {
        enable = true;
        lsp.servers = ["nixd" "nil"];
      };
      markdown.enable = true;
      yaml.enable = true;
      python = {
        enable = true;
        lsp.servers = ["ty"];
      };
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      typst.enable = true;
      bash.enable = true;
      lua.enable = true;
      toml.enable = true;
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          typescript = ["deno_fmt"];
          javascript = ["deno_fmt"];
          css = ["deno_fmt"];
          html = ["deno_fmt"];
          svelte = ["deno_fmt"];
          python = ["ruff_format"];
        };
        formatters = {
          ruff_format.command = "ruff";
          deno_fmt = {
            command = lib.getExe pkgs.deno;
            args = lib.generators.mkLuaInline ''
              function(self, ctx)
                local ext = vim.fn.fnamemodify(ctx.filename, ":e")
                return { "fmt", "--ext", ext, "-" }
              end
            '';
          };
        };
      };
    };
    luaConfigRC.lsp-roots = ''
      vim.lsp.config('denols', {
        root_markers = { 'deno.json', 'deno.jsonc' },
        workspace_required = true,
      })
    '';
  };
}
