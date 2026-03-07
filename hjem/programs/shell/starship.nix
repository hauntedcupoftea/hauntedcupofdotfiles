{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.starship;
  fishOn = config.dotfiles.shell.fish.enable;
in {
  options.dotfiles.shell.starship.enable =
    lib.mkEnableOption "starship cross-shell prompt";

  config = lib.mkIf cfg.enable {
    rum.programs.starship = {
      enable = true;
      integrations.fish.enable = fishOn;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[](bold blue)";
          error_symbol = "[✗](bold red)";
          vicmd_symbol = "[](bold green)";
        };
        nix_shell = {
          symbol = "󱄅";
          impure_msg = "";
          pure_msg = "";
          format = "via [$symbol$state( \($name\))]($style) ";
        };
        # jobs = {

        # };
      };
    };
  };
}
