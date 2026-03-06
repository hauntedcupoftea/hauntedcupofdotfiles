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
        size = 18.0;
        regular = {
          family = "FiraCode Nerd Font Mono Ret";
          style = "Normal";
          weight = 300;
        };
        bold = {
          family = "FiraCode Nerd Font Mono Ret";
          style = "Normal";
          weight = 500;
        };
        italic = {
          family = "FiraCode Nerd Font Mono Ret";
          style = "Italic";
        };
        bold-italic = {
          family = "FiraCode Nerd Font Mono Ret";
          style = "Italic";
          weight = 500;
        };
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
