{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.vesktop;

  videoDrivers = osConfig.services.xserver.videoDrivers or [];
  isNvidia = builtins.elem "nvidia" videoDrivers;
  isAMD = builtins.elem "amdgpu" videoDrivers;

  # AMD-focused HEVC decode flags
  hwAccelFlags =
    if isNvidia
    then ["--enable-features=VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,VaapiOnNvidiaGPUs"]
    else if isAMD
    then [
      "--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo"
      "--use-gl=angle"
      "--use-angle=vulkan"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
      "--ozone-platform=x11"
    ]
    else [];

  allFlags =
    (lib.optionals cfg.hardwareVideoAcceleration hwAccelFlags)
    ++ cfg.extraFlags;

  wrapVesktop = base: flags: let
    flagsString = lib.concatStringsSep " " flags;
  in
    base.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
      postFixup =
        (old.postFixup or "")
        + ''
          wrapProgram $out/bin/vesktop \
            --add-flags "${flagsString}"
        '';
    });

  defaultPackage =
    if allFlags == []
    then pkgs.vesktop
    else wrapVesktop pkgs.vesktop allFlags;
in {
  options.dotfiles.desktop.vesktop = {
    enable = lib.mkEnableOption "Vesktop Discord client with Vencord";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = defaultPackage;
      description = "Vesktop package to use. Set null to skip adding to packages.";
    };
    arrpc.enable = lib.mkEnableOption "arrpc (Discord RPC bridge)";
    hardwareVideoAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add vendor-appropriate hardware acceleration flags.";
    };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional raw Electron/Chromium flags.";
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

    xdg.config.files = lib.mkIf (cfg.themeDir != null) {
      "vesktop/themes".source = cfg.themeDir;
    };
  };
}
