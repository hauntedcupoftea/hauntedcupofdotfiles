{
  inputs,
  pkgs,
  config,
  ...
}: let
  grubTheme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.nixos;

  hasPrimary = config.dotfiles.desktop.enable && (builtins.any (m: m.primary) config.dotfiles.desktop.monitors);
  primaryMonitor =
    if hasPrimary
    then builtins.head (builtins.filter (m: m.primary) config.dotfiles.desktop.monitors)
    else null;
in {
  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = false;
      useOSProber = true;
      default = "saved";
      configurationLimit = 8;
      theme = grubTheme;
      gfxmodeEfi =
        if hasPrimary
        then "${primaryMonitor.resolution}x32"
        else "auto";
    };

    kernelPackages = pkgs.linuxPackages_zen;

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;

    # Add NTFS support
    supportedFilesystems = ["ntfs"];
  };
}
