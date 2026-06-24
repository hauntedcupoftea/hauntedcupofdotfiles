{pkgs, ...}: {
  # Add nerdfonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
  ];

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    hicolor-icon-theme
    gnome-themes-extra
  ];
}
