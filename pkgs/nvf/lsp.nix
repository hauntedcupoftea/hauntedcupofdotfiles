{
  lib,
  pkgs,
  ...
}: {
  vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = true;
      inlayHints.enable = true;
      trouble.enable = true;
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      ts = {
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
      tailwind.enable = true;
      json.enable = true;
      nix = {
        enable = true;
        lsp.servers = ["nixd"];
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
