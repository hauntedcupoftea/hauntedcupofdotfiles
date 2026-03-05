{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.rust;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.rust =
    lib.mkEnableOption "Rust language tooling (rust-analyzer)";

  config = lib.mkIf cfg {
    packages = [pkgs.rust-analyzer];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
      language = [{
        name = "rust";
        auto-format = true;
        formatter = {
          command = "rustfmt";
          args = ["--edition=2024"];
        };
        language-servers = ["rust-analyzer" "harper-ls"];
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.rust-analyzer = {
        binary.path = lib.getExe pkgs.rust-analyzer;
        initialization_options.check.command = "clippy";
      };
    };
  };
}
