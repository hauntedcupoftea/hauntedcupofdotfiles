{ inputs, system, ... }: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with inputs.astal.packages.${system}; [
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

  home.packages = with inputs.astal.packages.${system}; [
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
