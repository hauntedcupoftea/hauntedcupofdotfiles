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
          language-servers = [{ # Corrected: language-servers is a list
            command = "${pkgs.nil}/bin/nil";
          }];
          # Formatter: nixpkgs-fmt
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          # Indent settings
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
          language-servers = [{ 
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
            config = {
              python = {
                pythonPath = "${pkgs.python311}/bin/python"; # Or your project's venv
                analysis = {
                  typeCheckingMode = "strict"; # "off", "basic", "strict"
                };
              };
            };
          }];
          # Formatter: black
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = ["--quiet" "-"]; 
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
          # Language Server: rust-analyzer
          language-servers = [{ 
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          }];
          # Formatter: rustfmt
          formatter = {
            command = "${pkgs.rust-analyzer}/bin/rustfmt"; 
            args = ["--emit=stdout"];
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        # --- TypeScript ---
        {
          name = "typescript";
          auto-format = true;
          # Language Server: typescript-language-server
          language-servers = [{ 
            command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          }];
          # Formatter: prettier
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "typescript" "--stdin-filepath" "%"]; 
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        # --- Svelte ---
        {
          name = "svelte";
          auto-format = true;
          # Language Server: svelte-language-server
          language-servers = [{ 
            command = "${pkgs.svelte-language-server}/bin/svelte-language-server";
            args = ["--stdio"];
          }];
          # Formatter: prettier
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--stdin-filepath" "%"]; 
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
