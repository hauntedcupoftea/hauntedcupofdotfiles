{
  lib,
  inputs,
  pkgs,
  ...
}: let
  zen-browser =
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight;
in {
  users.users.packet = {
    isNormalUser = true;
    description = "Hriday Chauhan";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "openrazer" "plugdev" "gamemode" "input" "dialout"];
    packages = [];
  };

  hjem.users.packet = {
    enable = true;
    user = "packet";
    directory = "/home/packet";

    environment.sessionVariables = {
      EDITOR = "zed";
      VISUAL = "zed";
    };

    dotfiles = {
      shell = {
        cava.enable = true;
        helix.enable = true;
        fish.enable = true;
        starship.enable = true;
        eza.enable = true;
        btop.enable = true;
        bat.enable = true;
        yazi.enable = true;

        fzf.enable = true;
        zoxide.enable = true;

        podman.enable = true;
        packages = with pkgs; [
          bruno
          deno
          requestly
          sql-studio
          zrok
          zathura
          brightnessctl
          btrfs-progs
          desktop-file-utils
          fastfetch
          just
          git
          inetutils
          lm_sensors
          nload
          parted
          hauntedcupof-nvim
          wget2
        ];
      };

      theming.enable = true;

      desktop = {
        kitty.enable = true;
        wezterm.enable = true;
        zed.enable = true;
        mpv.enable = true;
        obs.enable = true;
        mangohud.enable = true;
        walker = {
          enable = true;
          runAsService = true;
          elephant.enable = true;
          config = {
            app_launch_prefix = "uwsm app -- ";
            ui.fullscreen = true;
            list.height = 200;
            websearch.prefix = "?";
            switcher.prefix = "/";
            general.runner_mode = "drun";
          };
        };
        vesktop = {
          enable = true;
          arrpc.enable = true;
          settings = {
            customTitleBar = false;
            disableMinSize = true;
            arRPC = true;
            hardwareVideoAcceleration = true;
            hardwareAcceleration = true;
            splashThemeing = true;
          };
          themeDir = ../custom-files/vesktop/themes;
          settingsDir = ../custom-files/vesktop/settings;
        };

        packages = with pkgs; [
          zen-browser
          jellyfin-media-player
          kdePackages.okular
          pinta
          gparted
          crosspipe
          easyeffects
          obsidian
          peazip
          remmina
          # dungeondraft
          element-desktop
          zapzap
          antigravity-fhs
          # screen capture stack (was home/desktop/screen-recording.nix)
          wf-recorder
          hyprshot
          grimblast
          slurp
          flameshot
          # gaming (was home/gaming/gaming.nix)
          protonup-qt
          protonplus
          heroic
          dualsensectl
          wineWow64Packages.stable
          winetricks
          goverlay
          samrewritten
          r2modman
          gale
          vulkan-tools
          lact
          # experimenting
          mission-center
        ];
      };

      services = {
        music = {
          enable = true;
          mpd.enable = true;
          rmpc = {
            enable = true;
          };
          discordRpc = {
            enable = true;
          };
          mpdris2 = {
            enable = true;
            multimediaKeys = true;
            notifications = true;
            mpd = {
              host = "127.0.0.1";
            };
          };
        };
        udiskie = {
          enable = true;
          automount = true;
          notify = true;
        };
      };

      environments.hyprland = {
        enable = true;
        terminal = "wezterm";
        hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "${lib.getExe pkgs.quickshell} ipc call lockscreen lock";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };
            listener = [
              {
                timeout = 150;
                on-timeout = "brightnessctl -s set 10";
                on-resume = "brightnessctl -r";
              }
              {
                timeout = 150;
                on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -rd rgb:kbd_backlight";
              }
              {
                timeout = 300;
                on-timeout = "${lib.getExe pkgs.quickshell} -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell/ ipc call lockscreen lock";
              }
              {
                timeout = 360;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
              }
            ];
          };
        };

        quickshell = {
          enable = true;
        };
      };
    };
  };

  nix.settings.trusted-users = ["packet"];
}
