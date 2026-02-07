{pkgs, ...}: {
  home.packages = with pkgs; [
    mangohud
    protonup-qt
    protonplus
    # lutris
    heroic
    dualsensectl
    wineWowPackages.stable
    winetricks
    goverlay
    samrewritten
    r2modman
    gale # might replace r2modman someday https://github.com/NixOS/nixpkgs/issues/468830
    vulkan-tools
  ];

  programs.mangohud = {
    enable = true;
    # TODO: add settings (copy from goverlay probably)
  };
}
