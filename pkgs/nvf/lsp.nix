{lib, ...}: let
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

      servers = {
        ty.cmd = lib.mkForce ["ty" "server"];
        dart.cmd = lib.mkForce ["dart" "language-server" "--protocol=lsp"];
        rust_analyzer.cmd = lib.mkForce ["rust-analyzer"];
        gopls.cmd = lib.mkForce ["gopls"];
        typescript-go.cmd = lib.mkForce ["tsgo" "--lsp" "--stdio"];
        svelte-language-server.cmd = lib.mkForce ["svelteserver" "--stdio"];
        tinymist.cmd = lib.mkForce ["tinymist"];

        nixd = {
          on_init = overrideCapabilities {
            # capabilities that are better provided by nil
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
        lsp.servers = ["typescript-go"];
      };
      css = {
        enable = true;
      };
      html = {
        enable = true;
      };
      svelte = {
        enable = true;
      };
      json.enable = true;
      nix = {
        enable = true;
        lsp.servers = ["nixd" "nil"];
      };
      markdown = {
        enable = true;
        lsp.servers = ["marksman"];
      };
      yaml.enable = true;
      python = {
        enable = true;
        lsp.servers = ["ty"];
      };
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      go.enable = true;
      typst.enable = true;
      bash.enable = true;
      lua.enable = true;
      toml.enable = true;
      qml.enable = true;
      dart = {
        enable = true;
        flutter-tools = {
          enable = true;
          flutterPackage = null;
        };
      };
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          typescript = ["prettier_fmt"];
          javascript = ["prettier_fmt"];
          css = ["prettier_fmt"];
          html = ["prettier_fmt"];
          svelte = ["prettier_fmt"];
          python = ["ruff_format"];
        };
        formatters = {
          ruff_format.command = "ruff";
          prettier_fmt.command = "prettier";
        };
      };
    };
  };
}
