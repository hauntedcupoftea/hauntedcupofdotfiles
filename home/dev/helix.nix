{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    helix
    scooter

    # general
    harper

    deno

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
          # https://github.com/helix-editor/helix/discussions/5764#discussioncomment-12968177
          "C-j" = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
            "select_mode"
            "goto_line_start"
            "normal_mode"
          ]; # Move line(s) down
          "C-k" = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
            "flip_selections"
          ]; # Move line(s) up
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
        insert = {"C-space" = "completion";};
        select = {"C-space" = "completion";};
      };
    };

    # Language specific configurations
    languages = {
      language-server = {
        biome = {
          command = lib.getExe pkgs.biome;
          args = ["lsp-proxy"];
        };

        harper-ls = {
          command = "harper-ls";
          args = ["--stdio"];
        };

        ty = {
          command = "ty";
          args = ["server"];
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
              imports.hosts."https://deno.land" = true;
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

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
        };

        svelte-ls = {
          command = lib.getExe pkgs.svelte-language-server;
          args = ["--stdio"];
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
          command = lib.getExe pkgs.typescript-language-server;
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
          language-servers = ["ty" "ruff" "harper-ls"];
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
          language-servers = ["rust-analyzer" "harper-ls"];
        }

        # --- TypeScript ---
        {
          name = "typescript";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {
              name = "deno-lsp";
              except-features = ["format"];
            }
            "biome"
            "harper-ls"
          ];
        }

        # --- TSX ---
        {
          name = "tsx";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {
              name = "deno-lsp";
              except-features = ["format"];
            }
            "biome"
            "harper-ls"
          ];
        }

        # --- JavaScript ---
        {
          name = "javascript";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {
              name = "deno-lsp";
              except-features = ["format"];
            }
            "biome"
            "harper-ls"
          ];
        }

        # --- JSX ---
        {
          name = "jsx";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {
              name = "deno-lsp";
              except-features = ["format"];
            }
            "biome"
            "harper-ls"
          ];
        }

        # --- Svelte ---
        {
          name = "svelte";
          auto-format = true;
          language-servers = [
            "svelte-ls"
            "tailwindcss-ls"
            "uwu-colors"
          ];
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
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = ["format"];
            }
            "biome"
          ];
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
