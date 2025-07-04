{ inputs, pkgs, ... }: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with inputs.astal.packages.${pkgs.system}; [
      apps
      auth
      battery
      bluetooth
      cava
      hyprland
      mpris
      network
      notifd
      powerprofiles
      tray
      wireplumber
    ];
  };

  home.packages = with inputs.astal.packages.${pkgs.system}; [
    astal4
    io
    apps
    auth
    battery
    bluetooth
    cava
    hyprland
    mpris
    network
    notifd
    powerprofiles
    tray
    wireplumber
  ];
}
