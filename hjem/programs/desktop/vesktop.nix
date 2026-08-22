{
  config,
  lib,
  pkgs,
  osConfig ? {},
  ...
}: let
  cfg = config.dotfiles.desktop.vesktop;

  videoDrivers = osConfig.hardware.videoDrivers or [];
  isNvidia = builtins.elem "nvidia" videoDrivers;

  hwAccelFlags =
    if isNvidia
    then ["--enable-features=VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,VaapiOnNvidiaGPUs"]
    else ["--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks"];
in {
  options.dotfiles.desktop.vesktop = {
    enable = lib.mkEnableOption "Vesktop Discord client with Vencord";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.vesktop;
      description = "Vesktop package to use. Set null to skip adding to packages.";
    };
    arrpc.enable = lib.mkEnableOption "arrpc (Discord RPC bridge)";
    hardwareVideoAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Write vendor-appropriate VAAPI/Vulkan flags to vesktop-flags.conf, auto-detected from this host's services.xserver.videoDrivers via osConfig.";
    };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional raw Electron/Chromium flags, appended after the hardware acceleration flags.";
    };
    themeDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory containing .css theme files, copied recursively to vesktop/themes/.";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs;
      (lib.optional (cfg.package != null) cfg.package)
      ++ lib.optional cfg.arrpc.enable arrpc;

    xdg.config.files = lib.mkMerge [
      (lib.mkIf (cfg.hardwareVideoAcceleration || cfg.extraFlags != []) {
        "vesktop-flags.conf".text =
          lib.concatStringsSep "\n" ((lib.optionals cfg.hardwareVideoAcceleration hwAccelFlags) ++ cfg.extraFlags)
          + "\n";
      })
      (lib.mkIf (cfg.themeDir != null) {"vesktop/themes".source = cfg.themeDir;})
    ];
  };
}
