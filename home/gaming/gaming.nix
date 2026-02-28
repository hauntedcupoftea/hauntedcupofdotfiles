{pkgs, ...}: {
  home.packages = with pkgs; [
    mangohud
    protonup-qt
    protonplus
    # lutris
    heroic
    dualsensectl
    wineWow64Packages.stable
    winetricks
    goverlay
    samrewritten
    r2modman
    gale # might replace r2modman someday https://github.com/NixOS/nixpkgs/issues/468830
    vulkan-tools
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      position = "top-right";
      gpu_temp = true;
      cpu_temp = true;

      gpu_power = true;
      cpu_power = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      cpu_mhz = true;

      throttling_status = true;
      throttling_status_graph = true;

      gpu_load_change = true;
      cpu_load_change = true;
      fps = true;
      frame_timing = true;

      toggle_hud = "F12";

      cpu_temp_limit = 90;
      gpu_temp_limit = 87;
    };
  };
}
