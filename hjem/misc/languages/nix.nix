{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.nix;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.nix =
    lib.mkEnableOption "Nix language tooling (nixd, nil, alejandra)";

  config = lib.mkIf cfg {
    packages = with pkgs; [nixd nil alejandra];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server = {
        nixd = {
          command = "nixd";
          args = ["--semantic-tokens" "--inlay-hints"];
        };
        nil-ls.command = lib.getExe pkgs.nil;
      };
      language = [{
        name = "nix";
        language-servers = ["nixd" "harper-ls" "nil-ls"];
        formatter.command = "alejandra";
        auto-format = true;
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp.nixd.binary.path = lib.getExe pkgs.nixd;
    };
  };
}
