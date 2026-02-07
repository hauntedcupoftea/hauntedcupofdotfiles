{pkgs, ...}: {
  services.udev.extraRules = ''
    # Ignore DualSense Touchpad as a mouse
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Override the DualSense UCM config files
  environment.etc."alsa/ucm2/USB-Audio/Sony/DualSense-PS5.conf".source = pkgs.writeText "DualSense-PS5.conf" ''
    Comment "Sony Corp. DualSense wireless controller (PS5)"

    Include.dhw.File "/common/directm.conf"

    # keep this use case first - wine compatibility
    Macro.0.DirectUseCase { Id="Direct" PlaybackChannels=4 CaptureChannels=2 }

    If.default.Prepend.SectionUseCase."Default" {
      Comment "Default"
      File "/USB-Audio/Sony/DualSense-PS5-HiFi.conf"
    }
  '';
}
