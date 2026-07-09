{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.starship;
  fishOn = config.dotfiles.shell.fish.enable;
  sep = "";
  sep_left = "";
in {
  options.dotfiles.shell.starship.enable =
    lib.mkEnableOption "starship cross-shell prompt";

  config = lib.mkIf cfg.enable {
    rum.programs.starship = {
      enable = true;
      integrations.fish.enable = fishOn;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;

        format = lib.concatStrings [
          "[${sep_left}](blue)"
          "$username"
          "[${sep}](fg:blue bg:cyan)"
          "$directory"
          "[${sep}](fg:cyan bg:purple)"
          "$git_branch"
          "$git_status"
          "$git_metrics"
          "[${sep}](fg:purple bg:green)"
          "$c"
          "$cpp"
          "$rust"
          "$golang"
          "$nodejs"
          "$deno"
          "$bun"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$lua"
          "$python"
          "$typst"
          "[${sep}](fg:green bg:yellow)"
          "$nix_shell"
          "$direnv"
          "[${sep}](fg:yellow)"
          "$docker_context"
          "$jobs"
          "$sudo"
          "$fill"
          "[${sep_left}](fg:bright-black)"
          "$cmd_duration"
          "$time"
          "[${sep}](fg:bright-black)"
          "[ ](fg:bright-black)"
          "$line_break"
          "$status"
          "$character"
        ];

        fill = {
          symbol = " ";
          style = "fg:black";
        };

        username = {
          show_always = true;
          style_user = "bg:blue fg:bright-white";
          style_root = "bg:red fg:bright-white";
          format = "[  $user ]($style)";
        };

        directory = {
          style = "fg:bright-white bg:cyan";
          format = "[  $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "";
          read_only = " ";
          substitutions = {
            "Documents" = " ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
            "dev" = " ";
          };
        };

        git_branch = {
          symbol = " ";
          style = "bg:purple";
          format = "[[ $symbol$branch ](fg:bright-white bg:purple)]($style)";
        };

        git_status = {
          style = "bg:purple";
          format = "[[($all_status$ahead_behind )](fg:bright-white bg:purple)]($style)";
          ahead = "\${count} ";
          behind = "\${count} ";
          diverged = "\${ahead_count}/\${behind_count} ";
          untracked = "?\${count} ";
          modified = "!\${count} ";
          staged = "+\${count} ";
          renamed = "»\${count} ";
          deleted = "\${count} ";
          conflicted = "=\${count} ";
        };

        git_metrics = {
          disabled = false;
          added_style = "fg:green bg:purple";
          deleted_style = "fg:red bg:purple";
          format = "([+$added ]($added_style))([-$deleted ]($deleted_style))";
        };

        nix_shell = {
          symbol = " ";
          style = "bg:yellow fg:bright-white";
          format = "[[ $symbol$state( \($name\)) ](fg:bright-white bg:yellow)]($style)";
          impure_msg = "󰞷 ";
          pure_msg = "";
          unknown_msg = "";
          disabled = false;
        };

        direnv = {
          disabled = false;
          style = "bg:yellow fg:bright-white";
          symbol = "";
          format = "[[ $symbol$loaded ](fg:bright-white bg:yellow)]($style)";
          allowed_msg = "";
          not_allowed_msg = " ";
          denied_msg = " ";
          loaded_msg = "";
          unloaded_msg = "";
        };

        docker_context = {
          symbol = " ";
          style = "bg:black";
          format = "[[ $symbol$context ](fg:cyan bg:black)]($style)";
        };

        jobs = {
          style = "bg:black";
          symbol = " ";
          format = "[[ $symbol$number ](fg:yellow bg:black)]($style)";
          threshold = 1;
        };

        sudo = {
          disabled = false;
          symbol = " ";
          style = "bg:black";
          format = "[[ $symbol](fg:red bg:black)]($style)[${sep}](fg:black)";
        };

        cmd_duration = {
          min_time = 2000;
          style = "bg:bright-black fg:bright-white";
          format = "[[  $duration ](fg:bright-white bg:bright-black)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%H:%M";
          style = "bg:bright-black fg:bright-white";
          format = "[[  $time ](fg:bright-white bg:bright-black)]($style)";
        };

        status = {
          disabled = false;
          style = "fg:red";
          symbol = "";
          not_executable_symbol = "-x ";
          not_found_symbol = "-? ";
          sigint_symbol = "SIGINT ";
          signal_symbol = " ";
          format = "[\\[$symbol$status\\] ]($style)";
          map_symbol = true;
        };

        c = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        cpp = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        rust = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        golang = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        nodejs = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        deno = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        bun = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        php = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        java = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        kotlin = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        haskell = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        lua = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        python = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };
        typst = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:bright-white bg:green)]($style)";
        };

        line_break.disabled = false;

        character = {
          disabled = false;
          success_symbol = "[OK ](bold blue)";
          error_symbol = "[ERR ](bold red)";
          vimcmd_symbol = "[hjkl ](bold green)";
          vimcmd_replace_one_symbol = "[ ](bold purple)";
          vimcmd_replace_symbol = "[ ](bold purple)";
          vimcmd_visual_symbol = "[ ](bold yellow)";
        };
      };
    };
  };
}
