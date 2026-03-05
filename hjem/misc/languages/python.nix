{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.languages.python;
  helixOn = config.dotfiles.shell.helix.enable;
  zedOn = config.dotfiles.desktop.zed.enable;
in {
  options.dotfiles.languages.python =
    lib.mkEnableOption "Python language tooling (uv, ty, ruff, python3)";

  config = lib.mkIf cfg {
    packages = with pkgs; [uv ty ruff python3];

    rum.programs.helix.languages = lib.mkIf helixOn {
      language-server = {
        ty = {command = "ty"; args = ["server"];};
        ruff = {command = "ruff"; args = ["server"];};
      };
      language = [{
        name = "python";
        language-servers = ["ty" "ruff" "harper-ls"];
        formatter = {command = "ruff"; args = ["format" "-"];};
        auto-format = true;
      }];
    };

    rum.programs.zed.settings = lib.mkIf zedOn {
      lsp = {
        ty.binary.path = lib.getExe pkgs.ty;
        ruff.binary.path = lib.getExe pkgs.ruff;
      };
    };
  };
}
