{ pkgs, ... }: {
  programs.sioyek = {
    enable = true;
    # The package can also just be added to systemPackages
    package = pkgs.symlinkJoin {
      name = "sioyek";
      paths = [ pkgs.sioyek ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    };
  };
}
