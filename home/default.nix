{ pkgs, ... }: {
  imports = [
    ./dev
    ./gaming
    ./hardware
    ./hyprland
    ./music
    ./shell
    ./sioyek.nix
    ./security.nix
    ./terminals
    ./theme
    ./utils
    ./xdg.nix
    # ./editors
    ./zen-browser.nix
  ];

  # TODO: Organize this better
  home.packages = with pkgs; [
    grimblast
    hyprshot
    wget
    git
    brightnessctl
    pavucontrol
    helvum
    easyeffects
    btop
    fastfetch
    obsidian
    overskride
    iwgtk
    peazip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    BROWSER = "zen";
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # for nvidia/wayland i think
  };
}
