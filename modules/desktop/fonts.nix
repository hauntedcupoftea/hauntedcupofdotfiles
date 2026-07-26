{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = ["FiraCode Nerd Font Mono" "DejaVu Sans Mono"];
    sansSerif = ["DejaVu Sans" "Noto Sans CJK SC"];
    serif = ["DejaVu Serif" "Noto Serif CJK SC"];
    emoji = ["Noto Color Emoji"];
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    hicolor-icon-theme
    gnome-themes-extra
  ];
}
