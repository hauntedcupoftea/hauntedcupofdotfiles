{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.markdown;
  helixOn = config.dotfiles.shell.helix.enable;
in {
  options.dotfiles.languages.markdown =
    lib.mkEnableOption "Markdown language tooling (marksman, markdown-oxide)";

  config = lib.mkIf cfg {
    packages = with pkgs; [marksman markdown-oxide];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language = [{
        name = "markdown";
        language-servers = ["marksman" "harper-ls"];
        formatter = {
          command = lib.getExe pkgs.deno;
          args = ["fmt" "-" "--ext" "md"];
        };
        auto-format = true;
      }];
    };
  };
}
