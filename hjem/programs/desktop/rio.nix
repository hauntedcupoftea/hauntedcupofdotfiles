{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.rio;
in {
  options.dotfiles.desktop.rio.enable =
    lib.mkEnableOption "rio terminal emulator";

  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    packages = [pkgs.rio];

    files.".config/rio/config.toml".source = (pkgs.formats.toml {}).generate "rio.toml" {
      shell = {
        program = lib.getExe pkgs.fish;
        args = ["--login"];
      };
      editor.program = lib.getExe pkgs.helix;
      fonts = {
        family = "Fira Code";
        use-drawable-chars = true;
        size = 18.0;
        extras = [
          {family = "Noto Sans Mono CJK SC";}
          {family = "Noto Sans Mono CJK KR";}
          {family = "Noto Sans Mono CJK JP";}
        ];
      };
      navigation = {
        mode = "Plain";
        use-split = false;
      };
      window = {
        decorations = "Enabled";
        mode = "Maximized";
        opacity = 0.85;
        blur = true;
      };
    };
  };
}
