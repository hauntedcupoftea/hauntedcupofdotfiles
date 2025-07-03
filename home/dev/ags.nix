{ inputs, pkgs, ... }: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with inputs.astal.packages.${pkgs.system}; [
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
