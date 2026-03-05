{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.cpp;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.cpp =
    lib.mkEnableOption "C/C++ language tooling (clangd, lldb)";

  config = lib.mkIf cfg {
    packages = with pkgs; [clang-tools lldb_20];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.clangd-ls = {
        command = "clangd";
        args = ["--compile-commands-dir=build"];
      };
      language = [{
        name = "cpp";
        language-servers = ["clangd-ls"];
        auto-format = true;
        formatter = {
          command = "clang-format";
          args = ["--style=Google"];
        };
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.clangd = {
        binary.path = "${pkgs.clang-tools}/bin/clangd";
        initialization_options.compilationDatabasePath = "build";
      };
    };
  };
}
