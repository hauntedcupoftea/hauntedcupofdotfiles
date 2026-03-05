{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.typst;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.typst =
    lib.mkEnableOption "Typst language tooling (typst, tinymist)";

  config = lib.mkIf cfg {
    packages = with pkgs; [typst tinymist];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server.tinymist = {
        command = lib.getExe pkgs.tinymist;
        config = {
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          formatterMode = "typstyle";
          formatterPrintWidth = 80;
        };
      };
      language = [{
        name = "typst";
        auto-format = true;
        language-servers = ["tinymist" "harper-ls"];
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.tinymist = {
        binary.path = lib.getExe pkgs.tinymist;
        settings = {
          exportPdf = "onType";
          formatterMode = "typstyle";
        };
      };
    };
  };
}
