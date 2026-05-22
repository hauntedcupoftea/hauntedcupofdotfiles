{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.go;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.go =
    lib.mkEnableOption "Go language tooling (golang)";

  config = lib.mkIf cfg {
    packages = with pkgs; [go gopls];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.go-pls = {
        command = "gopls";
      };
      language = [
        {
          name = "go";
          language-servers = ["go-pls"];
          auto-format = true;
          formatter = {
            command = "gofmt";
          };
        }
      ];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.gopls = {
        binary.path = "${pkgs.gopls}/bin/gopls";
      };
    };
  };
}
