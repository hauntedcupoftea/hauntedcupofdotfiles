{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.helix;
in {
  options.dotfiles.shell.helix = {
    enable = lib.mkEnableOption "helix editor";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra settings merged into rum.programs.helix.settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [scooter harper];

    rum.programs.helix = {
      enable = true;

      settings = lib.mkMerge [
        {
          theme = "base16_transparent"; # TODO: theming
          editor = {
            auto-format = true;
            end-of-line-diagnostics = "hint";
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            soft-wrap.enable = true;
            inline-diagnostics.cursor-line = "warning";
            indent-guides = {
              skip-levels = 1;
              character = "┆";
              render = true;
            };
          };
          keys = {
            normal = {
              "C-j" = [
                "extend_to_line_bounds"
                "delete_selection"
                "paste_after"
                "select_mode"
                "goto_line_start"
                "normal_mode"
              ];
              "C-k" = [
                "extend_to_line_bounds"
                "delete_selection"
                "move_line_up"
                "paste_before"
                "flip_selections"
              ];
              space.e = [
                ":sh rm -f /tmp/unique-file-h21a434"
                ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
                ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                ":open %sh{cat /tmp/unique-file-h21a434}"
                ":redraw"
                ":set mouse false"
                ":set mouse true"
              ];
              esc = ["collapse_selection" "keep_primary_selection"];
              "C-r" = [
                ":write-all"
                ":insert-output scooter >/dev/tty"
                ":redraw"
                ":reload-all"
                ":set mouse false"
                ":set mouse true"
              ];
            };
            insert."C-space" = "completion";
            select."C-space" = "completion";
          };
        }
        cfg.settings
      ];

      languages.language-server.harper-ls = {
        command = "harper-ls";
        args = ["--stdio"];
      };
    };
  };
}
