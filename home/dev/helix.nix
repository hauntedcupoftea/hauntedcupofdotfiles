{pkgs, ...}: {
  home.packages = with pkgs; [
    helix

    # Python, Rust, TypeScript & JavaScript in their respective files.

    # Nix
    nil # Nix Language Server
    nixpkgs-fmt # A popular formatter for Nix (alternative to nixfmt-classic)

    # Svelte
    svelte-language-server # Svelte LSP
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      # Enable this if you want format on save for all languages
      # that have a formatter configured.
      editor.auto-format = true;

      # LSP configuration
      editor.lsp = {
        display-messages = true; # Show LSP messages in status line
        # display-inlay-hints = true; # Uncomment to enable inlay hints if supported by LSP & theme
      };
    };

    # Language specific configurations
    languages = {
      language = [
        # --- Nix Refined ---
        {
          name = "nix";
          auto-format = true;
          # Language Server: nil
          language-server = {
            command = "${pkgs.nil}/bin/nil";
          };
          # Formatter: nixpkgs-fmt (or stick with nixfmt-classic if you prefer)
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          # Indent settings (optional, adjust to your preference)
          indent = {
            tab-width = 2;
            unit = "  "; # Two spaces
          };
        }

        # --- Python ---
        {
          name = "python";
          auto-format = true;
          # Language Server: pyright
          language-server = {
            # If using pyright:
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
            config = {
              # Example config for pyright, consult pyright docs
              python = {
                pythonPath = "${pkgs.python311}/bin/python"; # Or your project's venv
                analysis = {
                  typeCheckingMode = "basic"; # "off", "basic", "strict"
                };
              };
            };
          };
          # Formatter: black
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = ["--quiet" "-"]; # Read from stdin
          };
          indent = {
            tab-width = 4;
            unit = "    "; # Four spaces
          };
        }

        # --- Rust ---
        {
          name = "rust";
          auto-format = true;
          # Language Server: rust-analyzer (also handles formatting via rustfmt)
          language-server = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
          # Formatter: rustfmt (usually picked up by rust-analyzer)
          # If you need to specify it explicitly, or if rust-analyzer doesn't format:
          formatter = {
            command = "${pkgs.rust-analyzer}/bin/rustfmt"; # rustfmt is often bundled with rust-analyzer
            args = ["--emit=stdout"];
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        # --- TypeScript ---
        # (This configuration will also work for JavaScript files if you use them)
        {
          name = "typescript";
          auto-format = true;
          # Language Server: typescript-language-server
          language-server = {
            command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          };
          # Formatter: prettier
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            # Prettier needs a hint for the parser, and to read from stdin
            args = ["--parser" "typescript" "--stdin-filepath" "%"]; # % is placeholder for current file
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          # For JSX/TSX files
          # You might need to add a separate language entry or adjust if "typescript" doesn't cover it.
          # Often, the typescript LSP and prettier handle .tsx well.
        }
        # You can add a similar block for "javascript" if you want specific overrides
        # or if you don't want it to inherit from typescript settings implicitly.

        # --- Svelte ---
        {
          name = "svelte";
          auto-format = true;
          # Language Server: svelte-language-server
          language-server = {
            command = "${pkgs.svelte-language-server}/bin/svelte-language-server";
            args = ["--stdio"];
          };
          # Formatter: prettier with svelte plugin
          # Prettier needs to be told to use the svelte plugin.
          # This is often handled by prettier's own config files (e.g., .prettierrc.json)
          # or by command-line arguments if possible.
          # Ensure prettier-plugin-svelte is discoverable by prettier.
          # Adding it to home.packages helps, but prettier also looks for local project versions.
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            # Add prettier-plugin-svelte to node_modules where prettier can find it.
            # One way to ensure this is to have a project-local node_modules with prettier and the plugin,
            # or to globally install prettier and its svelte plugin in a way that they see each other.
            # For Helix, specifying the filepath is important for prettier to pick up correct parser via plugins.
            args = ["--stdin-filepath" "%"]; # Let prettier auto-detect svelte via filename and its config
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
    };
  };
}
