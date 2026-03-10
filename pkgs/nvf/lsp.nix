{...}: {
  vim = {
    # LSP core
    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true; # glyph in sign column when code actions available
      lspkind.enable = true; # pretty icons in completion menu
      inlayHints.enable = true; # parameter names, return types inline
      trouble.enable = true; # diagnostics panel (<leader>xx)
    };

    # Languages
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      ts = {
        enable = true;
        lsp.servers = ["denols"];
      };
      css.enable = true;
      html = {
        enable = true;
        lsp.servers = ["emmet-ls"];
      };
      svelte.enable = true;
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
      clang.enable = true;
      typst.enable = true;
      bash.enable = true;
      lua.enable = true;
      toml.enable = true;
    };

    formatter.conform-nvim.setupOpts.formatters = {
      biome.command = "biome";
      alejandra.command = "alejandra";
      ruff_format.command = "ruff";
    };

    luaConfigRC.lsp-roots = ''
      vim.lsp.config('denols', {
        root_markers = { 'deno.json', 'deno.jsonc' },
        workspace_required = true,
      })
    '';
  };
}
