{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
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
          };
          podman.enable = config.dotfiles.podman.enable;
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
          fish.enable = true;
          direnv.enable = true;
          starship.enable = true;
          zellij = {
            enable = true;
            exitOnSessionExit = true;
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
          toml = true;
          typst = true;
          uwu-colors = true;
          web = true;
          yaml = true;
        };

        desktop = {
          kitty.enable = true;
          rio.enable = true;
          teamviewer.enable = true;
          zed.enable = true;
          mpv.enable = true;
          obs.enable = true;
          mangohud.enable = true;

          packages = with pkgs; [
            jellyfin-media-player
            kdePackages.okular
            pinta
            gparted
            crosspipe
            easyeffects
            obsidian
            peazip
            remmina
            dungeondraft
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
          ];
        };

        environments.hyprland = {
          enable = true;
          quickshellConfigPath = "/home/tea/hauntedcupofdotfiles/custom-files/quickshell";
        };
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs;
      system = "x86_64-linux";
    };
    users.tea = {
      imports = [
        ../home
        inputs.catppuccin.homeModules.catppuccin
      ];
      home = {
        username = "tea";
        homeDirectory = "/home/tea";
        stateVersion = "24.11";
      };
      programs.home-manager.enable = true;
      xdg.userDirs.setSessionVariables = true; # don't exactly know what this do;
    };
  };

  nix.settings.trusted-users = ["tea"];
}
