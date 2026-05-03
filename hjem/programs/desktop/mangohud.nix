{
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.mangohud;
in {
  options.dotfiles.desktop.mangohud.enable =
    lib.mkEnableOption "MangoHud GPU/CPU overlay";

  config = lib.mkIf (nixosConfig.dotfiles.desktop.enable && cfg.enable) {
    files.".config/MangoHud/MangoHud.conf".text = ''
      position=top-right
      gpu_temp
      cpu_temp
      gpu_power
      cpu_power
      gpu_core_clock
      gpu_mem_clock
      cpu_mhz
      throttling_status
      throttling_status_graph
      gpu_load_change
      cpu_load_change
      fps
      frame_timing
      winesync
      toggle_hud=F12
    '';
  };
}
