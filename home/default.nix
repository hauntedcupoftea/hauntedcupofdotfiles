{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./profiles/desktop.nix
    # ./profiles/development.nix
    ./modules/terminals
    ./modules/shell
    # ./modules/editors
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "tea";
  home.homeDirectory = "/home/tea";

  # Basic packages that should be available to the user
  home.packages = with pkgs; [
    floorp
    vscodium
    vesktop
    wget
    git
    brightnessctl
    pavucontrol
    helvum
    easyeffects
    btop
    neofetch
    alejandra
  ];

  # Enable Firefox
  programs.firefox.enable = true;

  # This value determines the Home Manager release
  home.stateVersion = "24.11";
}
