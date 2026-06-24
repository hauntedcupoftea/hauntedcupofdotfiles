{
  config,
  nixosConfig,
  ...
}: {
  assertions = [
    {
      assertion = !config.rum.desktops.hyprland.enable || nixosConfig.dotfiles.desktop.enable;
      message = "rum.desktops.hyprland.enable requires dotfiles.desktop.enable = true on this host.";
    }
    {
      assertion = !config.dotfiles.desktop.zed.enable || nixosConfig.dotfiles.desktop.enable;
      message = "dotfiles.desktop.zed.enable requires dotfiles.desktop.enable = true on this host.";
    }
    {
      assertion = !config.rum.programs.mpv.enable || nixosConfig.dotfiles.desktop.enable;
      message = "rum.programs.mpv.enable requires dotfiles.desktop.enable = true on this host.";
    }
    {
      assertion = !config.rum.programs.obs-studio.enable || nixosConfig.dotfiles.desktop.enable;
      message = "rum.programs.obs-studio.enable requires dotfiles.desktop.enable = true on this host.";
    }
  ];
}
