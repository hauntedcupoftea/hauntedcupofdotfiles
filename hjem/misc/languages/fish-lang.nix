{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.fish;
  helixOn = config.dotfiles.shell.helix.enable;
in {
  options.dotfiles.languages.fish =
    lib.mkEnableOption "Fish language tooling (fish-lsp)";

  config = lib.mkIf cfg {
    packages = [pkgs.fish-lsp];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language = [{
        name = "fish";
        auto-format = true;
        language-servers = ["fish-lsp"];
      }];
    };
  };
}
