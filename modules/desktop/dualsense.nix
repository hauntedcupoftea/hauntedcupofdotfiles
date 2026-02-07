{...}: {
  services.udev.extraRules = ''
    # Ignore DualSense Touchpad as a mouse
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  nixpkgs.overlays = [
    (final: prev: {
      alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (oldAttrs: {
        patches =
          (oldAttrs.patches or [])
          ++ [
            ../../custom-files/patches/dualsense-alsa-fix.patch
          ];
      });
    })
  ];
}
