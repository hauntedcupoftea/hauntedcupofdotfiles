{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
    ./screen-recording.nix
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
    jellyfin-media-player
    kdePackages.okular # pdf editor
    pinta # paint
    gparted
    helvum # i don't know what this is but it's cool
    easyeffects # eq and shit
    obsidian # note-taking
    peazip # winrar but good
    remmina # rdp but good
    dungeondraft # custom derivation for map maker
    element-desktop # matrix
    zapzap # whatsapp client
    zmkBATx # zmk battery indicator
  ];
}
