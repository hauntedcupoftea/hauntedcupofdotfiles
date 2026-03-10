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

      dotfiles = {
        shell = {
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
            requestly
            sql-studio
            zrok
            zathura
            brightnessctl
            btrfs-progs
            desktop-file-utils
            fastfetch
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
          cpp = true;
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

          # Desktop GUI packages that don't warrant their own module yet
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
            # screen capture / screenshot stack
            wf-recorder
            hyprshot
            grimblast
            slurp
            flameshot
            # misc desktop utils
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
    };
  };

  nix.settings.trusted-users = ["tea"];
}
