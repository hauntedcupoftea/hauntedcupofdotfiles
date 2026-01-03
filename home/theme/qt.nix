{
  config,
  lib,
  ...
}: {
  home.file.".config/Kvantum/kvantum.kvconfig".text = lib.mkAfter (
    lib.optionalString (config.services.teamviewer.enable or false) ''

      [Applications]
      teamviewer=Fusion
    ''
  );
}
