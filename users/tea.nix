{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  zen-browser =
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight;
in {
  imports = [
    inputs.hjem.nixosModules.default
  ];

  users.users.tea = {
    isNormalUser = true;
    description = "Anand Chauhan";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "openrazer" "plugdev" "gamemode" "input" "dialout"];
    packages = [];
  };

  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
      ../hjem
    ];
    specialArgs = {
      inputs = inputs;
      nixosConfig = {
        dotfiles = {
          desktop = {
            enable = config.dotfiles.desktop.enable;
            monitors = config.dotfiles.desktop.monitors;
            audio.enable = config.dotfiles.desktop.audio.enable;
          };
          services = {
            enable = config.dotfiles.services.enable;
            podman.enable = config.dotfiles.services.podman.enable;
          };
        };
      };
    };
    clobberByDefault = true;
    users.tea = {
      enable = true;
      user = "tea";
      directory = "/home/tea";

      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      dotfiles = {
        shell = {
          cava.enable = true;
          helix.enable = true;
          fish = {
            enable = true;
            vim-mode = {
              enable = true;
              default-mode = "insert";
            };
          };
          direnv.enable = true;
          starship.enable = true;
          zellij = {
            enable = true;
            exitOnSessionExit = true;
            sshOnly = true;
          };

          eza.enable = true;
          btop.enable = true;
          bat.enable = true;
          yazi.enable = true;

          fzf.enable = true;
          zoxide.enable = true;

          git = {
            enable = true;
            userName = "hauntedcupoftea";
            userEmail = "andydchauhan@gmail.com";
            github.enable = true;
          };

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

        languages = {
          cpp = false;
          fish = true;
          markdown = true;
          nix = true;
          python = true;
          qml = true;
          rust = true;
          go = true;
          toml = true;
          typst = true;
          uwu-colors = true;
          web = true;
          yaml = true;
        };

        desktop = {
          kitty.enable = true;
          rio.enable = false;
          wezterm.enable = true;
          teamviewer.enable = true;
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
            zmkbatx
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
            # music
            kid3-qt
            # experimenting
            drawy
            drawio
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
            mpdscribble = {
              enable = true;
              verbose = 1;
              mpd = {
                host = "127.0.0.1";
                port = 6600;
              };
              endpoints = {
                "last.fm" = {
                  url = "http://post.audioscrobbler.com";
                  username = "hauntedcupoftea";
                  passwordFile = "/home/tea/.secrets/lastfm-password";
                };
              };
            };
          };
          udiskie = {
            enable = true;
            automount = true;
            notify = true;
          };
          zmkbatx.enable = true;
        };

        environments.hyprland = {
          enable = true;
          terminal = "wezterm";
          hypridle = {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "${lib.getExe pkgs.quickshell} -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell/ ipc call lockscreen lock";
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
  };

  nix.settings.trusted-users = ["tea"];
}
