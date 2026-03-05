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
          helix = {
            enable = true;
          };

          fish.enable = true;
          direnv.enable = true;

          git = {
            enable = true;
            userName = "hauntedcupoftea";
            userEmail = "andydchauhan@gmail.com";
            github.enable = true;
          };

          podman.enable = true;

          # NOTE: dotfiles.shell.kitty / starship / yazi / zellij are not
          # defined as hjem options yet — those modules live in home/ and
          # haven't been ported to hjem/programs/shell. Enabling them here
          # will cause "option does not exist" errors until ported.
          # kitty.enable = true;
          # starship.enable = true;
          # yazi.enable = true;
          # zellij.enable = true;

          packages = with pkgs; [
            bruno
            requestly
            sql-studio
            zrok
            zathura
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
          # NOTE: dotfiles.desktop.game-dev is not defined as a hjem option yet.
          # game-dev.enable = true;
          # mpv.enable = true;
          teamviewer.enable = true;
          zed.enable = true;

          packages = with pkgs; [
            jellyfin-media-player
            kdePackages.okular
            pinta
            gparted
            helvum
            easyeffects
            obsidian
            peazip
            remmina
            dungeondraft
            element-desktop
            zapzap
            zmkbatx
          ];
        };
      };

      rum = {
        desktops.hyprland = {
          enable = true;
          quickshell.configPath = "/home/tea/hauntedcupofdotfiles/custom-files/quickshell";
        };
      };
    };
  };

  # home-manager block kept until remaining home/ modules are ported to hjem
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
