{pkgs, ...}: {
  services.teamviewer.enable = true;

  services.teamviewer.package = pkgs.teamviewer.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/teamviewer \
          --unset QT_STYLE_OVERRIDE
      '';
  });
}
