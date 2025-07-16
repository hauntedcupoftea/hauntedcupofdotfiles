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
        end-of-line-diagnostics = "hint";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        inline-diagnostics = {
          cursor-line = "warning";
        };
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

      language-server.qmlls = {
        args = [ "-E" ];
        command = "qmlls";
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

      # language-specific configurations
      language = [
        # --- Nix ---
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          indent = { tab-width = 2; unit = "  "; };
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

        # --- QML ---
        {
          name = "qml";
          auto-format = true;
          indent = { tab-width = 4; unit = "    "; };
          language-servers = [ "qmlls" ];
        }
      ];
    };
  };
}
