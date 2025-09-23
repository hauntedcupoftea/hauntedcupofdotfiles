{pkgs, ...}: {
  imports = [
    ./dev
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
    ./mpv.nix
    ./xdg.nix
    ./zen-browser.nix
  ];

  # TO-DO: Organize this better
  home.packages = with pkgs; [
    grimblast # ss
    hyprshot # ss
    flameshot # better ss maybe
    wget # utility for downloading
    git # version control
    brightnessctl # brightness control
    pavucontrol # gui for volume
    helvum # i don't know what this is but it's cool
    easyeffects # eq and shit
    btop # system resource monitor
    fastfetch # cool sysinfo monitor
    obsidian # note-taking
    overskride # Bluetooth but good
    peazip # winrar but good
    remmina # rdp but good
    gparted # run with sudo -E
    btrfs-progs # for btrfs
    parted # maybe we need this
    inetutils
    zapzap # WhatsApp
    zmkBATx # split kb battery
    kdePackages.okular # pdf editor
  ];

  home.sessionVariables = {
    BROWSER = "zen";
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # for nvidia/wayland i think
  };
}
