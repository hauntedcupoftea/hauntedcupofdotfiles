{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    defaultProfiles = [
      "gpu-hq"
    ];
    scripts = with pkgs.mpvScripts; [mpris mpv-discord mpv-notify-send mpv-cheatsheet];
  };
}
