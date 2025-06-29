{ pkgs, ... }: {
  home.packages = with pkgs; [
    helix

    # docker/compose files
    # docker-compose-langserver
    # docker-langserver

    # Python, Rust, TypeScript & JavaScript in their respective files.
    # HTML/CSS/MD
    marksman
    markdown-oxide
    vscode-langservers-extracted

    # TOML
    taplo

    # YAML
    yaml-language-server

    # llvm DAP
    lldb_20

    # Nix
    nil # Nix Language Server
    nixpkgs-fmt # A popular formatter for Nix (alternative to nixfmt-classic)

    # Svelte
    svelte-language-server # Svelte LSP
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        auto-format = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp = {
          display-messages = true; # Show LSP messages in status line
          # display-inlay-hints = true; # Uncomment to enable inlay hints if supported by LSP & theme
        };
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };

      # Language specific configurations
      languages = {
        language-server.nil-ls = {
          command = "${pkgs.nil}/bin/nil";
        };

        language-server.pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };

        language-server.ruff = {
          command = "ruff";
          args = [ "server" ];
        };

        language-server.rust-analyzer-ls = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };

        language-server.typescript-ls = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };

        language-server.svelte-ls = {
          command = "${pkgs.svelte-language-server}/bin/svelteserver";
          args = [ "--stdio" ];
        };

        # 2. Language-specific configurations
        # This will create [[language]] blocks in languages.toml
        language = [
          # --- Nix ---
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            };
            indent = { tab-width = 2; unit = "  "; };
            # Reference the globally defined LSP by its name (without "language-server." prefix)
            language-servers = [ "nil-ls" ];
          }

          # --- Python ---
          {
            name = "python";
            auto-format = true;
            formatter = {
              command = "${pkgs.black}/bin/black";
              args = [ "--quiet" "-" ];
            };
            indent = { tab-width = 4; unit = "    "; };
            language-servers = [ "pyright" "ruff" ];
          }

          # --- Rust ---
          {
            name = "rust";
            auto-format = true;
            formatter = {
              command = "rustfmt";
              args = [ "--emit=stdout" ];
            };
            indent = { tab-width = 4; unit = "    "; };
            language-servers = [ "rust-analyzer-ls" ];
          }

          # --- TypeScript ---
          {
            name = "typescript";
            auto-format = true;
            # formatter = {
            #   command = "${pkgs.nodePackages.prettier}/bin/prettier";
            #   args = [ "--parser" "typescript" "--stdin-filepath" "%" ];
            # };
            indent = { tab-width = 2; unit = "  "; };
            language-servers = [ "typescript-ls" ];
          }

          # --- Svelte ---
          {
            name = "svelte";
            auto-format = true;
            # formatter = {
            #   command = "${pkgs.nodePackages.prettier}/bin/prettier";
            #   args = [ "--stdin-filepath" "%" ];
            # };
            indent = { tab-width = 2; unit = "  "; };
            language-servers = [ "svelte-ls" ];
          }
        ];
      };
    };
  };
}
