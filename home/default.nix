{...}: {
  imports = [
    # ./dev # moved to hjem
    ./desktop
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
  ];

  home.sessionVariables = {
    BROWSER = "zen";
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # for nvidia/wayland i think
  };
}
