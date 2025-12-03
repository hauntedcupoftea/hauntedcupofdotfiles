{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    helix
    scooter

    # general
    harper

    # Python, Rust, TypeScript & JavaScript in their respective files.
    # HTML/CSS/Markdown
    marksman
    markdown-oxide
    vscode-langservers-extracted

    # fish
    fish-lsp

    # TOML
    taplo

    # YAML
    yaml-language-server

    # llvm DAP
    lldb_20
    clang-tools

    # Nix
    nixd
    nil # Nix Language Servers
    alejandra # A popular formatter for Nix (alternative to nixfmt-classic)

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
        soft-wrap.enable = true;
        inline-diagnostics = {
          cursor-line = "warning";
        };
        indent-guides = {
          skip-levels = 1;
          character = "┆";
          render = true;
        };
      };
      keys = {
        normal = {
          space = {
            # https://github.com/helix-editor/helix/wiki/Recipes#advanced-file-explorer-with-yazi
            e = [
              ":sh rm -f /tmp/unique-file-h21a434"
              ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
              ":insert-output echo \"x1b[?1049h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file-h21a434}"
              ":redraw"
              ":set mouse false"
              ":set mouse true"
            ];
          };
          esc = ["collapse_selection" "keep_primary_selection"];
          "C-r" = [
            ":write-all"
            ":insert-output scooter >/dev/tty"
            ":redraw"
            ":reload-all"
            ":set mouse false"
            ":set mouse true"
          ];
        };
      };
    };

    # Language specific configurations
    languages = {
      language-server = {
        harper-ls = {
          command = "harper-ls";
          args = ["--stdio"];
        };

        basedpyright = {
          command = "basedpyright-langserver";
          args = ["--stdio"];
        };

        clangd-ls = {
          command = "clangd";
          args = ["--compile-commands-dir=build"];
        };

        deno-lsp = {
          command = lib.getExe pkgs.deno;
          args = ["lsp"];
          environment.NO_COLOR = "1";
          config.deno = {
            enable = true;
            lint = true;
            unstable = true;
            suggest = {
              completeFunctionCalls = false;
              imports = {hosts."https://deno.land" = true;};
            };
            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = true;
              parameterNames.enabled = "all";
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = true;
            };
          };
        };

        nixd = {
          command = "nixd";
          args = [
            "--semantic-tokens"
            "--inlay-hints"
          ];
        };

        nil-ls = {
          command = lib.getExe pkgs.nil;
        };

        qmlls = {
          args = ["-E"];
          command = "qmlls";
        };

        ruff = {
          command = "ruff";
          args = ["server"];
        };

        rust-analyzer-ls = {
          command = "rust-analyzer";
        };

        tailwindcss-ls = {
          command = lib.getExe pkgs.tailwindcss-language-server;
          args = ["--stdio"];
        };

        tinymist = {
          command = lib.getExe pkgs.tinymist;
          config = {
            exportPdf = "onType";
            outputPath = "$root/target/$dir/$name";
            formatterMode = "typstyle";
            formatterPrintWidth = 80;
          };
        };

        typescript-ls = {
          command = lib.getExe pkgs.nodePackages.typescript-language-server;
          args = ["--stdio"];
          config = {
            typescript-language-server.source = {
              addMissingImports.ts = true;
              fixAll.ts = true;
              organizeImports.ts = true;
              removeUnusedImports.ts = true;
              sortImports.ts = true;
            };
          };
        };

        svelte-ls = {
          command = "svelteserver";
          args = ["--stdio"];
        };

        uwu-colors = {
          command = "${pkgs.uwu-colors}/bin/uwu_colors";
        };

        vscode-css-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = ["--stdio"];
          config = {
            provideFormatter = true;
            css.validate.enable = true;
            scss.validate.enable = true;
          };
        };
      };

      # language-specific configurations
      language = let
        deno = lang: {
          command = lib.getExe pkgs.deno;
          args = ["fmt" "-" "--ext" lang];
        };

        prettier = lang: {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" lang];
        };
      in [
        # --- C++ ---
        {
          name = "cpp";
          language-servers = ["clangd-ls"];
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = ["--style=Google"];
          };
        }

        # --- Nix ---
        {
          name = "nix";
          language-servers = ["nixd" "harper-ls" "nil-ls"];
          formatter.command = "alejandra";
          auto-format = true;
        }

        # --- Markdown ---
        {
          name = "markdown";
          language-servers = ["marksman" "harper-ls"];
          formatter = deno "md";
          auto-format = true;
        }

        # --- Python ---
        {
          name = "python";
          language-servers = [
            "basedpyright"
            "ruff"
            "harper-ls"
          ];
          formatter = {
            command = "ruff";
            args = ["format" "-"];
          };
          auto-format = true;
        }

        # --- Rust ---
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
            args = ["--edition=2024"];
          };
          language-servers = ["rust-analyzer-ls" "harper-ls"];
        }

        # --- TypeScript ---
        {
          name = "typescript";
          auto-format = true;
          language-servers = ["typescript-ls" "harper-ls"];
          formatter = deno "ts";
        }

        # --- JavaScript ---
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["typescript-ls" "harper-ls"];
          formatter = deno "js";
        }

        # --- JSX ---
        {
          name = "jsx";
          auto-format = true;
          language-servers = ["typescript-ls"];
          formatter = deno "jsx";
        }

        # --- TSX ---
        {
          name = "tsx";
          auto-format = true;
          language-servers = ["typescript-ls"];
          formatter = deno "tsx";
        }

        # --- Svelte ---
        {
          name = "svelte";
          auto-format = true;
          language-servers = ["typescript-ls" "svelte-ls" "tailwindcss-ls" "uwu-colors"];
          formatter = prettier "svelte";
        }

        # --- HTML ---
        {
          name = "html";
          auto-format = true;
          language-servers = ["vscode-html-language-server" "tailwindcss-ls" "uwu-colors"];
          formatter = deno "html";
        }

        # --- CSS ---
        {
          name = "css";
          auto-format = true;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls" "uwu-colors"];
        }

        # --- SCSS ---
        {
          name = "scss";
          auto-format = true;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls" "uwu-colors"];
        }

        # --- JSON ---
        {
          name = "json";
          auto-format = true;
          language-servers = ["vscode-json-language-server"];
          formatter = deno "json";
        }

        # --- TOML ---
        {
          name = "toml";
          auto-format = true;
          language-servers = ["taplo-lsp"];
        }

        # --- YAML ---
        {
          name = "yaml";
          auto-format = true;
          language-servers = ["yaml-language-server"];
        }

        # --- Fish ---
        {
          name = "fish";
          auto-format = true;
          language-servers = ["fish-lsp"];
        }

        # --- Typst ---
        {
          name = "typst";
          auto-format = true;
          language-servers = ["tinymist" "harper-ls"];
        }

        # --- QML ---
        {
          name = "qml";
          auto-format = true;
          language-servers = ["qmlls" "uwu-colors"];
        }
      ];
    };
  };
}
