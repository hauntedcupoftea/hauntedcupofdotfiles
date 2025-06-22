{ pkgs, ... }: {
  home.packages = with pkgs; [
    (pkgs.vesktop.override {
      commandLineArgs = [
        # tells electron to use the VA-API for both decoding and encoding video.
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
        # Forces hardware acceleration even if electron thinks your GPU is unsupported.
        "--ignore-gpu-blocklist"
        # General performance improvements for rendering.
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        # ozone hint for wayland/hyprland.
        "--ozone-platform-hint=auto"
      ];
    })
    arrpc
  ];

  programs.vesktop = {
    enable = true;
  };

  home.file = {
    ".config/vesktop/themes" = {
      source = ../../custom-files/vesktop/themes;
      recursive = true;
    };
  };

  # for discord RPC
  services.arrpc = {
    enable = true;
  };
}
