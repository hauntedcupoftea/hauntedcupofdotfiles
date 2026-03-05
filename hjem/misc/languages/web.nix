{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.web;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
  uwuOn = config.dotfiles.languages.uwu-colors;
  denoFmt = lang: {
    command = lib.getExe pkgs.deno;
    args = ["fmt" "-" "--ext" lang];
  };
in {
  options.dotfiles.languages.web =
    lib.mkEnableOption "Web language tooling (deno, biome, TS/Svelte/CSS/HTML/JSON LSPs)";

  config = lib.mkIf cfg {
    packages = with pkgs; [
      deno
      nodejs
      pnpm
      biome
      typescript-language-server
      svelte-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
    ];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server = {
        biome = {
          command = lib.getExe pkgs.biome;
          args = ["lsp-proxy"];
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
        svelte-ls = {
          command = lib.getExe pkgs.svelte-language-server;
          args = ["--stdio"];
        };
        tailwindcss-ls = {
          command = lib.getExe pkgs.tailwindcss-language-server;
          args = ["--stdio"];
        };
        vscode-css-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = ["--stdio"];
          config = {
            provideFormatter = true;
            css.validate.enable = true;
            scss.validate.enable = true;
          };
        };
      };
      language = [
        {
          name = "typescript";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {name = "deno-lsp"; except-features = ["format"];}
            "biome"
            "harper-ls"
          ];
        }
        {
          name = "tsx";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {name = "deno-lsp"; except-features = ["format"];}
            "biome"
            "harper-ls"
          ];
        }
        {
          name = "javascript";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {name = "deno-lsp"; except-features = ["format"];}
            "biome"
            "harper-ls"
          ];
        }
        {
          name = "jsx";
          roots = ["deno.json" "deno.jsonc" "package.json"];
          auto-format = true;
          language-servers = [
            {name = "deno-lsp"; except-features = ["format"];}
            "biome"
            "harper-ls"
          ];
        }
        {
          name = "svelte";
          auto-format = true;
          language-servers = ["svelte-ls" "tailwindcss-ls"]
            ++ lib.optional uwuOn "uwu-colors";
        }
        {
          name = "html";
          auto-format = true;
          language-servers = ["vscode-html-language-server" "tailwindcss-ls"]
            ++ lib.optional uwuOn "uwu-colors";
          formatter = denoFmt "html";
        }
        {
          name = "css";
          auto-format = true;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"]
            ++ lib.optional uwuOn "uwu-colors";
        }
        {
          name = "scss";
          auto-format = true;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"]
            ++ lib.optional uwuOn "uwu-colors";
        }
        {
          name = "json";
          auto-format = true;
          language-servers = [
            {name = "vscode-json-language-server"; except-features = ["format"];}
            "biome"
          ];
          formatter = denoFmt "json";
        }
      ];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp = {
        deno.binary.path = lib.getExe pkgs.deno;
        biome.binary.path = lib.getExe pkgs.biome;
        svelte-language-server.binary.path = lib.getExe pkgs.svelte-language-server;
        tailwindcss-language-server.binary.path = lib.getExe pkgs.tailwindcss-language-server;
        typescript-language-server.binary.path = lib.getExe pkgs.typescript-language-server;
      };
    };
  };
}
